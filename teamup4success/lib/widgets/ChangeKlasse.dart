import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/AdminEditUser.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChangeKlasse extends StatefulWidget {
  const ChangeKlasse({Key? key, required this.Email}) : super(key: key);
  final String Email;
  @override
  _ChangeKlasseState createState() => _ChangeKlasseState();
}

class _ChangeKlasseState extends State<ChangeKlasse> {

  late TextEditingController textControllerOldKlasse;
  late FocusNode textFocusNodeOldKlasse;
  bool _isEditingOldKlasse = false;

  late TextEditingController textControllerNewKlasse;
  late FocusNode textFocusNodeNewKlasse;
  bool _isEditingNewKlasse= false;

  String Jahrgang = '';


  @override
  void initState() {
    textControllerOldKlasse = TextEditingController();
    textControllerOldKlasse.text = '';
    textFocusNodeOldKlasse = FocusNode();
    textControllerNewKlasse = TextEditingController();
    textControllerNewKlasse.text = '';
    textFocusNodeNewKlasse = FocusNode();
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
                    'Klasse ändern!!',
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
                    'Neue Klasse:',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 50.0),
                      DropdownButton(
                        dropdownColor: Colors.white,
                        focusColor: Colors.purple,
                        value: Jahrgang,
                        onChanged: (String? newValue){
                          setState((){
                            Jahrgang = newValue!;
                          });
                        },
                        items: <String>['1. Jahrgang', '2. Jahrgang', '3. Jahrgang', '4. Jahrgang','5. Jahrgang']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                            .toList(),
                        hint: new Text("Wähle deinen Jahrgang aus"),
                      ),
                    ],
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
                      store.collection('users').where('email',isEqualTo: widget.Email).get().then((value) => {
                        store.collection('users').doc(value.docs.single.get('uid')).update({'year' : Jahrgang})
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AdminEditUser(email: widget.Email),
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
