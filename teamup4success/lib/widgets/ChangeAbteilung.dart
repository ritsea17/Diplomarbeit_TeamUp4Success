import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/AdminEditUser.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChangeAbteilung extends StatefulWidget {
  const ChangeAbteilung({Key? key, required this.Email}) : super(key: key);
  final String Email;
  @override
  _ChangeAbteilungState createState() => _ChangeAbteilungState();
}

class _ChangeAbteilungState extends State<ChangeAbteilung> {

  late TextEditingController textControllerOldAbteilung;
  late FocusNode textFocusNodeOldAbteilung;
  bool _isEditingOldAbteilung = false;

  late TextEditingController textControllerNewAbteilung;
  late FocusNode textFocusNodeNewAbteilung;
  bool _isEditingNewAbteilung = false;

  String abteilung = '';


  @override
  void initState() {
    textControllerOldAbteilung = TextEditingController();
    textControllerOldAbteilung.text = '';
    textFocusNodeOldAbteilung = FocusNode();
    textControllerNewAbteilung = TextEditingController();
    textControllerNewAbteilung.text = '';
    textFocusNodeNewAbteilung = FocusNode();
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
                    'Abteilung ändern!!',
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
                    'Neue Abteilung:',
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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("department_list").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> subjectItems = [];
                          for (int i = 0; i < snapshot.data!.size; i++) {
                            String snap = snapshot.data!.docs[i].get('Abteilung');
                            subjectItems.add(
                              DropdownMenuItem(
                                child: Text(snap),
                                value: "${snap}",
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 50.0),
                              DropdownButton(
                                items: subjectItems,
                                onChanged: (dynamic subjectValue) {
                                  setState(() {
                                    abteilung = subjectValue;
                                  });
                                },
                                value: abteilung,
                                hint: new Text("Wähle deine Abteilung aus"),
                              ),
                            ],
                          );
                        }
                        throw Exception("");
                      }),

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
                        store.collection('users').doc(value.docs.single.get('uid')).update({'department' : textControllerNewAbteilung.text})
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
