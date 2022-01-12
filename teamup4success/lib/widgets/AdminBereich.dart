import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/widgets/AddAdmin.dart';
import 'package:explore/widgets/AdminEditUser.dart';
import 'package:explore/widgets/AllAdmins.dart';
import 'package:explore/widgets/AllDepartments.dart';
import 'package:explore/widgets/AllStudents.dart';
import 'package:explore/widgets/ShowSubjectsForDepartment.dart';
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

class Adminbereich extends StatefulWidget {

  @override
  _AdminbereichState createState() => _AdminbereichState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
User? cuser= _auth.currentUser;
final store = FirebaseFirestore.instance;
late List users;

void getUsers(){
  store.collection("users").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      users.add(result.data()['email']);
    });
  });
}

class _AdminbereichState extends State<Adminbereich>
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
              Center(
                child: Column(
                  children: [

                    Container(
                        padding: EdgeInsets.only(top: 100.0,bottom: 10.0),
                        child: TextButton(
                          child: Text('Alle Schüler/innen und Lehrer/innen anzeigen:',style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AllStudents()
                            );
                          },

                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 100.0,bottom: 10.0),
                        child: TextButton(
                          child: Text('Abteilung hinzufügen/löschen:',style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AllDepartments()
                            );
                          },

                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 100.0,bottom: 10.0),
                        child: TextButton(
                          child: Text('Fach hinzufügen/löschen:',style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => ShowSubjectsForDepartment()
                            );
                          },

                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 100.0,bottom: 10.0),
                        child: TextButton(
                          child: Text('Administrator/in hinzufügen/löschen:',style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AllAdmins()
                            );
                          },

                        )
                    )
                  ],
                ),
              ),


              ],

    ),
    ),
    ),

          );


    }
}
