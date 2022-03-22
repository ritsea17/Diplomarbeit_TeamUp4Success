import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/widgets/ChatMessage.dart';
import 'package:explore/widgets/web_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:explore/widgets/explore_drawer.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';

class UserDieNachhilfeGebenPage extends StatefulWidget {
  const UserDieNachhilfeGebenPage({Key? key, required this.subject}) : super(key: key);
  final List subject;

  @override
  _UserDieNachhilfeGebenState createState() => _UserDieNachhilfeGebenState();
}


class _UserDieNachhilfeGebenState extends State<UserDieNachhilfeGebenPage>
{
  int dropdownGegenstand = 1;
  int dropdownRolle = 1;
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener()
  {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState()
  {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? cuser= _auth.currentUser;
    final store = FirebaseFirestore.instance;

    print(widget.subject);
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
        backgroundColor:
        Theme.of(context).bottomAppBarColor.withOpacity(_opacity)
        ,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'TeamUp4Success',
          style: TextStyle(
            color: Colors.blueGrey[100],
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            letterSpacing: 3,
          ),
        ),
      )
          : PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: TopBarContents(_opacity),

      ),
      drawer: ExploreDrawer(),
      body: WebScrollbar(
        color: Colors.blueGrey,
        backgroundColor: Colors.blueGrey.withOpacity(0.3),
        width: 10,
        heightFraction: 0.3,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [

              Container(
                  padding: EdgeInsets.only(top: 150.0,bottom: 10.0),
                  child: RichText(

                    text: TextSpan(
                      text: 'User die im Ausgewählten Fach Nachhilfe geben:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                      children: [

                        // Use WidgetSpan instead of TextSpan, which allows you to have a child widget
                        WidgetSpan(
                          // Use StreamBuilder to listen on the changes of your Firestore document.
                          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("users").where('department',isEqualTo: widget.subject[1])
                                .snapshots(),
                            builder: (context, snapshot) {
                            Map lessons = {};
                            List name = [];
                            List email=[];
                            List uid = [];
                            Map details = {};
                            List teacherAndYears= [];
                            List givetrue = [];
                            var snap = snapshot.data!.docs.toList();
                            snap.forEach((element) {
                              if(element.data().keys.contains('givePrivateLessons')) {
                                givetrue.add(1);
                              }
                              else{
                                givetrue.add(0);
                              }

                              });
                              for(int i = 0;i<snapshot.data!.docs.length-1;i++) {
                                if(givetrue[i]==1) {
                                  lessons = snapshot.data!.docs[i].get('givePrivateLessons');
                                  if(snapshot.data!.docs[i].get('uid')!= cuser!.uid) {
                                    if (lessons.containsKey(widget.subject[0])) {
                                      String years = snapshot.data!.docs[i].get('givePrivateLessons.${widget
                                              .subject[0]}.${'providedYears'}');
                                      List s = years.split(';');
                                      if (s.contains(widget.subject[2])) {
                                        name.add(snapshot.data!.docs[i].get('display_name'));
                                        email.add(snapshot.data!.docs[i].get('email'));
                                        uid.add(snapshot.data!.docs[i].get('uid'));
                                        details = snapshot.data!.docs[i].get('givePrivateLessons.${widget
                                                .subject[0]}');
                                        teacherAndYears.add(details.values.toList());
                                      }
                                    }
                                  }
                                } else{
                                  print('keine Nachhilfe');
                                }
                              };
                              return ListView.builder(
                                itemCount: name.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 10.0),
                                itemBuilder: (ctx, i) {
                                  return ListTile(
                                      leading: Icon(Icons.account_circle,size: 40,),
                                      title: Text(
                                        name[i]   , style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                      ),),
                                      subtitle: Text(
                                       email[i]  , style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                      ),),
                                      trailing: Text(
                                       'Professor/in: '+teacherAndYears[i][0] , style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                      ),),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Messagepage(
                                          chatman: uid[i],
                                            chatname: name[i]
                                        ));
                                    }
                                  );
                                },
                              );
                            }, // Get the document snapshot// Get the data in the text field
                          ),
                        ),
                      ],
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}

