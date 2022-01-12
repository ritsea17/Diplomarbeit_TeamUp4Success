import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/screens/home_page_admin.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/auth_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterDialog extends StatefulWidget {
  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<RegisterDialog> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  late DocumentReference ref;
  var itemsList =['Informatik', 'Automatisierung', 'Mechatronik', 'Robotik'];
  String abteilung = 'Bitte Abteilung auswählen';
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;
  late String username;
  late String password;
  late String abt;
  late String klasse;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  late TextEditingController textControllerBenutzername;
  late FocusNode textFocusNodeBenutzername;
  bool _isEditingBenutzername = false;

  late TextEditingController textControllerKlasse;
  late FocusNode textFocusNodeKlasse;
  bool _isEditingKlasse = false;

  bool _isRegistering = false;
  bool _isLoggingIn = false;

  String? loginStatus;
  Color loginStringColor = Colors.green;


  List admins=[];


  String? _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.!+-/=]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
      if(value.contains('htl-kaindorf') || value.contains('htlkaindorf') ){
        return null;
      }else {
        return 'Bitte Schulemail benutzen';
      }
    }

    return null;
  }
  String? _validateBenutzername(String value) {
    value = value.trim();
    return null;
  }

  String? _validateKlasse(String value) {
    value = value.trim();
    return null;
  }


  String? _validatePassword(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of password should be greater than 6';
      }
    }

    return null;
  }
  bool _isUserEmailVerified= false;

  bool _verifyEmail() {

    final User? user = _auth.currentUser;
    _isUserEmailVerified = user!.emailVerified;
    if (_isUserEmailVerified==true) {
      return true;
    }
    else{
      return false;
    }
  }

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerBenutzername = TextEditingController();
    textControllerKlasse = TextEditingController();
    textControllerEmail.text = '';
    textControllerPassword.text = '';
    textControllerBenutzername.text = '';
    textControllerKlasse.text = '';
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    textFocusNodeBenutzername = FocusNode();
    textFocusNodeKlasse = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    var screenSize = MediaQuery.of(context).size;

    final FirebaseAuth _auth1 = FirebaseAuth.instance;
    final User? cuser = _auth1.currentUser;

    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 400,
            color: Theme.of(context).backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SizedBox(
                    height: screenSize.height*0.12,
                    width: screenSize.width*0.08,

                    child: Image.asset(
                      'assets/images/Logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Center(

                  child: Text(
                    'TEAM UP 4 SUCCESS',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Benutzername:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 18,
                      // fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: TextField(
                    focusNode: textFocusNodeBenutzername,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: textControllerBenutzername,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingBenutzername = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeBenutzername.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodeEmail);
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                          width: 3,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "xyz",
                      fillColor: Colors.white,
                      errorText: _isEditingBenutzername
                          ? _validateBenutzername(textControllerBenutzername.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Email address:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 18,
                      // fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: TextField(
                    focusNode: textFocusNodeEmail,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: textControllerEmail,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingEmail = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeEmail.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodePassword);
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                          width: 3,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "Email",
                      fillColor: Colors.white,
                      errorText: _isEditingEmail
                          ? _validateEmail(textControllerEmail.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Password:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: TextField(
                    focusNode: textFocusNodePassword,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: textControllerPassword,
                    obscureText: true,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingPassword = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodePassword.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodeKlasse);
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                          width: 3,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "Password",
                      fillColor: Colors.white,
                      errorText: _isEditingPassword
                          ? _validatePassword(textControllerPassword.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Abteilung:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 18,
                      // fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child:
                  DropdownButton(
                    dropdownColor: Colors.white,
                    focusColor: Colors.purple,
                    value: abteilung,
                    onChanged: (String? newValue){
                     setState((){
                       abteilung = newValue!;
                     });
                     },
                      items: <String>['Informatik', 'Automatiesierung', 'Mechatronik', 'Robotik']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Klasse:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 18,
                      // fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: TextField(
                    focusNode: textFocusNodeKlasse,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: textControllerKlasse,
                    obscureText: false,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingKlasse = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeKlasse.unfocus();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                          width: 3,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "1AHIF",
                      fillColor: Colors.white,
                      errorText: _isEditingKlasse
                          ? _validateKlasse(textControllerBenutzername.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.blueGrey[800]!,
                                width: 1,
                              )),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isLoggingIn = true;
                                textFocusNodeEmail.unfocus();
                                textFocusNodePassword.unfocus();
                                textFocusNodeBenutzername.unfocus();
                                textFocusNodeKlasse.unfocus();
                              });
                              if (_validateEmail(textControllerEmail.text) ==
                                  null &&
                                  _validatePassword(
                                      textControllerPassword.text) ==
                                      null) {
                                await signInWithEmailPassword(
                                    textControllerEmail.text,
                                    textControllerPassword.text)
                                    .then((result) {
                                  if (result != null && verified == true) {
                                    print(result);
                                    setState(() {
                                      loginStatus =
                                      'You have successfully logged in';
                                      loginStringColor = Colors.green;
                                    });

                                    store.collection('admins').doc('2ateEChEcqnI1gIFw7Hh').get().then((value) =>{
                                      value.data()!.forEach((key, value) {
                                        admins=value;
                                      })
                                    });

                                    if(admins.contains(cuser!.email)) {
                                      Future.delayed(
                                          Duration(milliseconds: 500),
                                              () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) =>
                                                      HomePageAdmin(),
                                                ));
                                          });

                                    }else{
                                      Future.delayed(
                                          Duration(milliseconds: 500),
                                              () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) =>
                                                      HomePage(),
                                                ));
                                          });
                                    }
                                  }
                                }).catchError((error) {
                                  print('Login Error: $error');
                                  setState(() {
                                    loginStatus =
                                    'Error occured while logging in';
                                    loginStringColor = Colors.red;
                                  });
                                });
                              } else {
                                setState(() {
                                  loginStatus = 'Please enter email & password';
                                  loginStringColor = Colors.red;
                                });
                              }
                              setState(() {
                                _isLoggingIn = false;
                                textControllerEmail.text = '';
                                textControllerPassword.text = '';
                                _isEditingEmail = false;
                                _isEditingPassword = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                              ),
                              child: _isLoggingIn
                                  ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  new AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                                  : Text(
                                'Anmelden',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.blueGrey[800]!,
                                width: 1,
                              )),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {

                              setState(() {
                                _isRegistering = true;
                              });
                            if (_validateEmail(textControllerEmail.text) ==
                                null && _validatePassword(textControllerPassword.text) ==
                                null && _validateBenutzername(textControllerBenutzername.text)==null &&
                                _validateKlasse(textControllerKlasse.text)==null) {
                              await registerWithEmailPassword(
                                  textControllerEmail.text,
                                  textControllerPassword.text)
                                  .then((result) {
                                if (result != null) {
                                  print(result);
                                  setState(() {
                                    loginStatus =
                                    'You have successfully logged in';
                                    loginStringColor = Colors.green;

                                    store.collection("users").doc(uid).set(
                                        {
                                          'display_name' : textControllerBenutzername.text,
                                          'email' : textControllerEmail.text,
                                          'department' : abteilung,
                                          'klasse' : textControllerKlasse.text,
                                          'uid': uid.toString()
                                        });

                                    username = textControllerBenutzername.text;
                                    //cuser!.displayName=textControllerBenutzername.toString();
                                  });
                                }
                              }).catchError((error) {
                                print('Login Error: $error');
                                setState(() {
                                  loginStatus =
                                  'Error occured while registering';
                                  loginStringColor = Colors.red;
                                });
                              });
                            } else {
                              setState(() {
                                loginStatus = 'Please enter email & password';
                                loginStringColor = Colors.red;
                              });
                            }
                              setState(() {
                                _isLoggingIn = false;
                                textControllerEmail.text = '';
                                textControllerPassword.text = '';
                                _isEditingEmail = false;
                                _isEditingPassword = false;
                                textControllerKlasse.text ='';
                                textControllerBenutzername.text='';
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                              ),
                              child: _isRegistering
                                  ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  new AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                                  : Text(
                                'Registrieren',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loginStatus != null
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: Text(
                      loginStatus!,
                      style: TextStyle(
                        color: loginStringColor,
                        fontSize: 14,
                        // letterSpacing: 3,
                      ),
                    ),
                  ),
                )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                  ),
                  child: Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.blueGrey[200],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Willkommen bei TeamUp4Success',
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      // letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}