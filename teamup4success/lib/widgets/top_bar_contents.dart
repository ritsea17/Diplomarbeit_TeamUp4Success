import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/Fachauswahl.dart';
import 'package:explore/widgets/MeineFaecher.dart';
import 'package:explore/widgets/SchuelerverwaltungAdmin.dart';
import 'package:explore/widgets/profil.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/auth_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TopBarContents extends StatefulWidget {
  final double opacity;
  String? name;
  String? email;
  String? passwort;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TopBarContents(this.opacity);

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}


class _TopBarContentsState extends State<TopBarContents> {
  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  Future<void> _KeinUserAngemeldet() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kein User Angemeldet'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Um TeamUp4Success zu nutzen müssen Sie sich bitte Anmelden oder Registrieren'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Verstanden'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? cuser= _auth.currentUser;

    var screenSize = MediaQuery
        .of(context)
        .size;

      return PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Container(
            color: Colors.purple,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              RichText(
                  text: TextSpan(
                      text: 'Team Up 4 Success',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            Future.delayed(Duration(milliseconds: 500),
                                    () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => HomePage(),
                                  ));
                                })
              ),
              ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: screenSize.width / 8),
                        InkWell(
                          onHover: (value) {
                            setState(() {
                              value
                                  ? _isHovering[0] = true
                                  : _isHovering[0] = false;
                            });
                          },
                          onTap: () {
                            if(cuser!.uid.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) => MeineFaecherPage()
                              );
                            }else{
                              AlertDialog(
                                    title: Text('Kein User Angemeldet'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Um TeamUp4Success zu nutzen müssen Sie sich bitte Anmelden oder Registrieren'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Verstanden'),
                                        onPressed: () {
                                          Future.delayed(Duration(milliseconds: 500),
                                                  () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .pushReplacement(MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) => HomePage(),
                                                ));
                                              });
                                        },
                                      ),
                                    ],
                                  );
                                }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Meine Fächer',
                                style: TextStyle(
                                  color: _isHovering[0]
                                      ? Colors.blue[200]
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _isHovering[0],
                                child: Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onHover: (value) {
                            setState(() {
                              value
                                  ? _isHovering[1] = true
                                  : _isHovering[1] = false;
                            });
                          },
                          onTap: () {

                            if(cuser!.uid.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) => FachauswahlPage()
                              );
                            }else{
                              _KeinUserAngemeldet();
                            }

                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Fachauswahl',
                                style: TextStyle(
                                  color: _isHovering[1]
                                      ? Colors.blue[200]
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _isHovering[1],
                                child: Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onHover: (value) {
                            setState(() {
                              value
                                  ? _isHovering[2] = true
                                  : _isHovering[2] = false;
                            });
                          },
                          onTap: () {
                            if(cuser!.uid.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) => SchuelerverwaltungPage()
                              );
                            }else{
                              _KeinUserAngemeldet();
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Termine',
                                style: TextStyle(
                                  color: _isHovering[2]
                                      ? Colors.blue[200]
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _isHovering[2],
                                child: Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onHover: (value) {
                            setState(() {
                              value
                                  ? _isHovering[3] = true
                                  : _isHovering[3] = false;

                            });
                          },
                          onTap: () {
                            if(cuser!.uid.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) => ProfilPage()
                              );
                            }else{
                              _KeinUserAngemeldet();
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Profil',
                                style: TextStyle(
                                  color: _isHovering[3]
                                      ? Colors.blue[200]
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _isHovering[3],
                                child: Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width / 50,
                  ),
                  InkWell(
                    onHover: (value) {
                      setState(() {
                        value ? _isHovering[4] = true : _isHovering[4] = false;
                      });
                    },
                    onTap: userEmail == null
                        ? () {
                      showDialog(
                        context: context,
                        builder: (context) => AuthDialog(),
                      );
                    }
                        : null,
                    child: userEmail == null
                        ? Text(
                      'Anmelden',
                      style: TextStyle(
                        color: _isHovering[4] ? Colors.black : Colors.white60,
                      ),
                    )
                        : Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl!)
                              : null,
                          child: imageUrl == null
                              ? Icon(
                            Icons.account_circle_rounded,
                            size: 30,
                          )
                              : Container(),
                        ),
                        SizedBox(width: 4),
                        Text(
                          name ?? userEmail!,
                            style: TextStyle(
                            color: _isHovering[4]
                                ? Colors.black
                                : Colors.white60,
                          ),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _isProcessing
                              ? null
                              : () async {
                            setState(() {
                              _isProcessing = true;
                            });
                            await signOut().then((result) {
                              print(result);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }).catchError((error) {
                              print('Sign Out Error: $error');
                            });
                            setState(() {
                              _isProcessing = false;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: _isProcessing
                                ? CircularProgressIndicator()
                                : Text(
                              'Abmelden',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    }


}
