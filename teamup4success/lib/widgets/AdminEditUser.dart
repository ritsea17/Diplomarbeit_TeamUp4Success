import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/ChangePassword.dart';
import 'package:explore/widgets/ChangeUserName.dart';
import 'package:explore/widgets/ChangeKlasse.dart';
import 'package:explore/widgets/ChangeAbteilung.dart';
import 'package:explore/widgets/ChangeEmail.dart';
import 'package:explore/widgets/web_scrollbar.dart';
import 'package:explore/widgets/explore_drawer.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:explore/widgets/Register.dart';




class AdminEditUser extends StatefulWidget {
  static const String route = 'Profil';
  const AdminEditUser({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  _AdminEditUserState createState() => _AdminEditUserState();

}

final FirebaseAuth _auth = FirebaseAuth.instance;
User? cuser= _auth.currentUser;
final store = FirebaseFirestore.instance;


class _AdminEditUserState extends State<AdminEditUser> {
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

  String? getUsername(){
    String? username;
    store.collection("users").doc(cuser!.uid.toString()).get().then((value){
      username = value.data()!["display_name"];
    });

    return username;
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
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    RichText(

                      text: TextSpan(
                        children: [
                          // Use WidgetSpan instead of TextSpan, which allows you to have a child widget
                          WidgetSpan(

                            // Use StreamBuilder to listen on the changes of your Firestore document.
                            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .where('email',isEqualTo: widget.email)
                                  .snapshots(),
                              builder: (context, snapshot) {// Get the data in the text field


                                return Text(snapshot.data!.docs.single['display_name'] ?? 'Kein Name',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 3,

                                ),); // Show loading if text is null
                              },
                            ),
                          ),
                        ],
                      ),
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
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    RichText(

                      text: TextSpan(

                        children: [
                          // Use WidgetSpan instead of TextSpan, which allows you to have a child widget
                          WidgetSpan(

                            // Use StreamBuilder to listen on the changes of your Firestore document.
                            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .where('email',isEqualTo: widget.email)
                                  .snapshots(),
                              builder: (context, snapshot) {// Get the data in the text field


                                return Text(snapshot.data!.docs.single['klasse'] ?? 'Keine Klasse',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 3,

                                ),); // Show loading if text is null
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.create),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      color: Colors.purple,
                      iconSize: 30,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeKlasse(Email : widget.email),
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
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    RichText(

                      text: TextSpan(

                        children: [
                          // Use WidgetSpan instead of TextSpan, which allows you to have a child widget
                          WidgetSpan(

                            // Use StreamBuilder to listen on the changes of your Firestore document.
                            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .where('email',isEqualTo: widget.email)
                                  .snapshots(),
                              builder: (context, snapshot) {// Get the data in the text field


                                return Text(snapshot.data!.docs.single['abteilung'] ?? 'Keine Abteilung',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 3,

                                ),); // Show loading if text is null
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.create),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      color: Colors.purple,
                      iconSize: 30,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeAbteilung(Email : widget.email),
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
                        "Email: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      RichText(

                        text: TextSpan(

                          children: [
                            // Use WidgetSpan instead of TextSpan, which allows you to have a child widget
                            WidgetSpan(

                              // Use StreamBuilder to listen on the changes of your Firestore document.
                              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .where('email',isEqualTo: widget.email)
                                    .snapshots(),
                                builder: (context, snapshot) {// Get the data in the text field


                                  return Text(snapshot.data!.docs.single['email'] ?? 'Keine Email',style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 3,

                                  ),); // Show loading if text is null
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.create),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.purple,
                        iconSize: 30,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ChangeEmail(Email : widget.email),
                          );

                        },
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
