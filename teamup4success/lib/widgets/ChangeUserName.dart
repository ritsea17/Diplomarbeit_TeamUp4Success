import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChangeUsername extends StatefulWidget {
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {

  late TextEditingController textControllerOldUsername;
  late FocusNode textFocusNodeOldUsername;
  bool _isEditingOldUsername = false;

  late TextEditingController textControllerNewUsername;
  late FocusNode textFocusNodeNewUsername;
  bool _isEditingNewUsername = false;

  @override
  void initState() {
    textControllerOldUsername = TextEditingController();
    textControllerOldUsername.text = '';
    textFocusNodeOldUsername = FocusNode();
    textControllerNewUsername = TextEditingController();
    textControllerNewUsername.text = '';
    textFocusNodeNewUsername = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? cuser= _auth.currentUser;
    final store = FirebaseFirestore.instance;

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
                    'Benutzername ändern!!',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 30,
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
                    'Neuer Benutzername:',
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
                    focusNode: textFocusNodeNewUsername,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: textControllerNewUsername,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingNewUsername = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeNewUsername.unfocus();
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
                    ),
                  ),
                ),
                Center(


                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    iconSize: 40,
                    color: Colors.green,
                    onPressed: () {
                      store.collection("users").doc(cuser!.uid.toString()).update({'display_name': textControllerNewUsername.text.toString()});
                      showDialog(
                        context: context,
                        builder: (context) => ProfilPage(),
                      );
                    },
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
