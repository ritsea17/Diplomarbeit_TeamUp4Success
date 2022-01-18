import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/widgets/AddAdmin.dart';
import 'package:explore/widgets/AddDepartment.dart';
import 'package:explore/widgets/AdminEditUser.dart';
import 'package:explore/widgets/web_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:explore/widgets/explore_drawer.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';
import 'package:explore/screens/home_page.dart';

class AllAdmins extends StatefulWidget {

  @override
  _AllAdminsState createState() => _AllAdminsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
User? cuser= _auth.currentUser;
final store = FirebaseFirestore.instance;
late List users;


class _AllAdminsState extends State<AllAdmins>
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
                      text: 'Alle Administratoren/innen',
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
                                .collection("admins")
                                .snapshots(),
                            builder: (context, snapshot) {

                              List document = snapshot.data!.docs.single['email'];
                              return ListView.builder(
                                itemCount: document.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 10.0),
                                itemBuilder: (ctx, i) {
                                  return ListTile(
                                    title: Text(
                                      document[i],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                      ),),
                                    trailing:
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      iconSize: 30.0,
                                      color: Colors.red,
                                      onPressed: () {
                                        store.collection("admins").doc('adminemails').update(
                                            {
                                              'email' : FieldValue.arrayRemove([document[i]])
                                            });
                                      },
                                    ),

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
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddAdmin(),
                  );
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),

              ),
            ],
          ),
        ),
      ),
    );
  }
}