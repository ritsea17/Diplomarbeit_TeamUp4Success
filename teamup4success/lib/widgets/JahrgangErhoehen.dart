import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Jahrgangerhoehen extends StatefulWidget {
  const Jahrgangerhoehen({Key? key, required this.newDate}) : super(key: key);
  final String newDate;

  @override
  _JahrgangerhoehenState createState() => _JahrgangerhoehenState();
}

class _JahrgangerhoehenState extends State<Jahrgangerhoehen> {


  int aktJahrgang=0;
  String jahr="";
  List a = [];

  void UpdateClass(){
    int neuerJahrgang = aktJahrgang +1;
    String Jahrgang = neuerJahrgang.toString() + "." + " " + "Jahrgang";
    store.collection('users').doc(cuser!.uid).update({'year': Jahrgang});
    store.collection('users').doc(cuser!.uid).update({'updateDepartmentDate': widget.newDate});
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

  @override
  void initState() {
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
                      'assets/images/TU4SIcon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Center(

                  child: Text(
                    'Jahrgang ändern!!',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 30,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Center(

                  child: Text(
                    'Um TeamUp4Success weiter nutzen zu können musst du deinen '
                        'Jahrgang erhöhen, oder bestätigen das du deine Klasse wiederholst.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  ),
                  onPressed: () {
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
                  },
                  child: Text('Jahrgang wiederholen'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  ),
                  onPressed: () { 
                    store.collection('users').doc(cuser!.uid).get().then((value) => {
                      jahr = value.get('year'),
                       a = jahr.split('.'),
                      aktJahrgang = int.parse(a[0])
                    }).whenComplete(() => UpdateClass());
                    
                  },
                  child: Text('Jahrgang erhöhen'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
