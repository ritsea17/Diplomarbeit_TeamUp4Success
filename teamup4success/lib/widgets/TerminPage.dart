import 'package:explore/widgets/TerminErstellPage.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TerminPage extends StatefulWidget {

  @override
  _TerminPageState createState() => _TerminPageState();
}

class _TerminPageState extends State<TerminPage> {
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;
  double lefts = 0;
  double rights = 0;
  Color fieldColor = Colors.white;
  Color textColor = Colors.white;
  Color dateColor = Colors.black;
  double blurRadius2 = 0;
  final myControllerMsg = TextEditingController();
  var otherUser = '';
  List uids = [];
  List location = [];
  List start_time = [];
  List end_time = [];
  List price = [];
  List date = [];
  List namen=[];
  var container;
  String username="";
  List document_id = [];
  var name = '';


  getOtherPerson(String person)
  {
    List fullString = person.split('|');
    if(fullString.first == FirebaseAuth.instance.currentUser!.uid.toString())
    {
      person = fullString.last;
    }
    else
    {
      person = fullString.first;
    }
    return person;
  }

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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              new Container(
                margin: const EdgeInsets.only(top: 120 .0),
                child: Text(
                  'Meine Termine:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('meeting').orderBy('date').get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                      if (snapshot.hasError) {
                        return Text("Error "+ snapshot.data.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            right: MediaQuery.of(context).size.width * 0.06),
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                            if(data['token'].toString().contains(FirebaseAuth.instance.currentUser!.uid.toString())) {
                              otherUser = data['token'];
                              otherUser = getOtherPerson(otherUser);
                              uids.add(otherUser);
                              location.add(data['location']);
                              start_time.add(data['start_time']);
                              end_time.add(data['end_time']);
                              price.add(data['price']);
                              date.add(data['date']);
                              document_id.add(document.id);
                            }
                            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance.collection("users").snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                  for(int i = 0;i<=uids.length-1;i++)
                                  {
                                    var snap = snapshot.data!.docs.where((element) =>(element.get('uid')==uids[i]));
                                    print(snap.single['display_name']);
                                    namen.add(snap.single['display_name']);
                                  };
                                  if(namen.length == uids.length) {
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context).size.height * 0.02,
                                              left: MediaQuery.of(context).size.width * lefts,
                                              right:
                                              MediaQuery.of(context).size.width * rights),
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: ListView.builder(
                                            itemCount: uids.length,
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, i) {
                                              return ListTile(
                                                title: Text(
                                                  namen[i],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 3,
                                                  ),),
                                                subtitle: Column(
                                                  children: [
                                                    Text(
                                                      'Raum: ' + location[i] + ' | ' + 'Preis: ' + price[i],
                                                      style: TextStyle(color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.delete),
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      iconSize: 30.0,
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        FirebaseFirestore.instance.collection('meeting').doc(document_id[i]).delete();
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => TerminPage(),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                trailing: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height *
                                                          0.008),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .end,
                                                    children: [
                                                      Text(
                                                        start_time[i] + ' - ' +
                                                            end_time[i],
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      Text(
                                                        date[i].toString(),
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ],
                                                  ),

                                                ),
                                              );

                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  else{
                                    return SizedBox(height: 0,width: 0);
                                  }
                                }
                            );
                          }).toList(),
                        ),
                      );
                    }
                ),
              ),
              Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TerminErstellPage(),
                      );
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add),
                  )
              )
            ],
          ),
        )
    );
  }
}
