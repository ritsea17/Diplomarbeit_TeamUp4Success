import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/web_scrollbar.dart';
import 'package:explore/widgets/explore_drawer.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:explore/widgets/Register.dart';

import 'ChangeClass.dart';
import 'ChangeUserName.dart';

class ProfilPage extends StatefulWidget {
  static const String route = 'Profil';
  @override
  _ProfilPageState createState() => _ProfilPageState();


}


class _ProfilPageState extends State<ProfilPage> {
  late String daten;
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? cuser= _auth.currentUser;

    final store = FirebaseFirestore.instance;

    store.collection("users").doc(uid).get().then((data)
    {

    });

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
              Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: screenSize.height*0.5,
                      width: screenSize.width,
                      child: Image.asset(
                        'assets/images/bild123.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
              child: Row(
                  children: [
                    Text(
                      'Benutzername: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.create),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      color: Colors.purple,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeUsername(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            Center(
              child: Row(
                children: [
                  Text(
                      "Klasse: ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
              ),
                  ),
                  IconButton(
                    icon: Icon(Icons.create),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Colors.purple,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ChangeClass(),
                      );
                    },
                  ),
                ],
              ),
            ),
              Center(
              child: Row(

                children: [

                  Text(
                      "Abteilung: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.create),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Colors.purple,
                    onPressed: () {

                    },
                  ),

                ],
              ),
              ),
              Center(

              child: Row(
                children: [
                Text(
                    "Email: ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                  ),
                ),
                  Text(
                    ""+cuser!.email.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              )
              ),

            ],
          ),
        ),
      ),
    );
  }
}
