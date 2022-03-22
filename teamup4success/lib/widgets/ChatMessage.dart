import 'package:explore/widgets/TerminErstellPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'Fachauswahl.dart';

class Messagepage extends StatefulWidget {
  const Messagepage(
      {Key? key, required this.chatman, required this.chatname})
      : super(key: key);
  final String chatman;
  final String chatname;

  @override
  _MessagepageState createState() => _MessagepageState();
}

class _MessagepageState extends State<Messagepage> {
  double lefts = 0;
  double rights = 0;
  Color fieldColor = Colors.white;
  Color textColor = Colors.white;
  Color dateColor = Colors.black;
  double blurRadius2 = 0;
  final myControllerMsg = TextEditingController();
  DateTime _now = DateTime.now();
  var message = '';
  var container;

  @override
  addData() async {
    await FirebaseFirestore.instance.collection('messages').add({
      'token': '${FirebaseAuth.instance.currentUser!.uid}|${widget.chatman}',
      'from': FirebaseAuth.instance.currentUser!.uid,
      'to': widget.chatman,
      'time': DateTime.now(),
      'message': myControllerMsg.text,
    });
    myControllerMsg.clear();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.purple,
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.height * 0.02),
              ),
              Text("${widget.chatname}",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('messages').
                    orderBy('time', descending: true).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                            if(data['token'].toString().contains(FirebaseAuth.instance.currentUser!.uid.toString())
                                && data['token'].toString().contains('|')
                                && data['token'].toString().contains(widget.chatman.toString()))
                            {
                              DateTime myDateTime = (data['time']).toDate();
                              if (FirebaseAuth.instance.currentUser!.uid == data['to'])
                              {
                                lefts = 0;
                                rights = 0.2;
                                fieldColor = Colors.grey;
                                textColor = Colors.white;
                                dateColor = Colors.white;
                                message = data['message'];
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height * 0.02,
                                      left: MediaQuery.of(context).size.width * lefts,
                                      right:
                                      MediaQuery.of(context).size.width * rights),
                                  decoration: BoxDecoration(
                                    color: fieldColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      message,
                                      style: TextStyle(color: textColor),
                                    ),
                                    trailing: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).size.height *
                                              0.008),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${DateFormat('hh:mm a').format(myDateTime)}",
                                            style: TextStyle(color: dateColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              else
                              {
                                lefts = 0.2;
                                rights = 0;
                                fieldColor = Colors.green;
                                textColor = Colors.black;
                                dateColor = Colors.black;
                                message = data['message'];
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height * 0.02,
                                      left: MediaQuery.of(context).size.width * lefts,
                                      right:
                                      MediaQuery.of(context).size.width * rights),
                                  decoration: BoxDecoration(
                                    color: fieldColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      message,
                                      style: TextStyle(color: textColor),
                                    ),
                                    trailing: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).size.height *
                                              0.008),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${DateFormat('hh:mm a').format(myDateTime)}",
                                            style: TextStyle(color: dateColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            return SizedBox(
                              height: 0,
                              width: 0,
                            );
                          }).toList(),
                        ),
                      );
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      offset: Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: myControllerMsg,
                    cursorColor: Colors.black,
                    style: TextStyle(
                        color: Colors.black,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      // fillColor: field1Color,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide.none,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => TerminErstellPage(),
                                );
                              },
                              icon: Icon(Icons.calendar_today_outlined)),
                          IconButton(
                              onPressed: addData,
                              icon: Icon(Icons.send)),
                        ],
                      ),
                      hintText: 'Message...',
                      hintStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
              // ),
            ],
          ),
        ));
  }
}
