import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/screens/home_page.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/AddDeleteSubject.dart';
import 'package:explore/widgets/AdminBereich.dart';
import 'package:explore/widgets/AdminEditUser.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AddSubject extends StatefulWidget {
  const AddSubject({Key? key, required this.department}) : super(key: key);
  final String department;
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {

  late TextEditingController textControllerSubject;
  late FocusNode textFocusNodeSubject;
  bool _isEditingSubject = false;
bool isChecked= false;





  @override
  void initState() {
    textControllerSubject= TextEditingController();
    textControllerSubject.text = '';
    textFocusNodeSubject = FocusNode();


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
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Name des neuen Fachs',
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
                    focusNode: textFocusNodeSubject,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: textControllerSubject,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingSubject = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeSubject.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodeSubject);
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
                Padding(
                    padding: const EdgeInsets.only(
                      top:10,
                      left: 20.0,
                      right: 20,
                    ),
                    child: Text('Vertiefungsfach: ')
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: Checkbox(
                    checkColor: Colors.purple,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
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

                      final ref=store.collection('subject_list').doc(widget.department);
                      if(isChecked==true){
                        ref.update({
                          'elective': FieldValue.arrayUnion(
                              [textControllerSubject.text])
                        });
                      }else {
                        ref.update({
                          'subject': FieldValue.arrayUnion(
                              [textControllerSubject.text])
                        });
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AddDeleteSubject(department : widget.department),
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
