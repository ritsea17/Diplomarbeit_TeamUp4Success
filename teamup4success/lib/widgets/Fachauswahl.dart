import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/widgets/Register.dart';
import 'package:explore/widgets/Login.dart';
import 'package:explore/widgets/explore_drawer.dart';
import 'package:explore/widgets/web_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';

class FachauswahlPage extends StatefulWidget {

  @override
  _FachauswahlState createState() => _FachauswahlState();
}

class _FachauswahlState extends State<FachauswahlPage>
{


  int dropdownGegenstand = 1;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  int dropdownRolle = 1;
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;
  final textcontroller = TextEditingController();
  bool checkboxVisibilty = false;
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  var selectedSubject;
  var selectedAbt;
  String jahrgang = '';

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

  Map addMap()
  {
    return {
      'providedYears' : jahrgang,
      'teacherName' : textcontroller
    };
  }

  // To show Selected Item in Text.
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.80
        ? _scrollPosition / (screenSize.height * 0.80)
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
    child:Column(children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(top: 150.0),
            child: Text(
              'Neues Fach:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Gegenstand:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('uid',isEqualTo: _auth.currentUser!.uid.toString())
                .snapshots(),
            builder: (context, snapshot)
            {// Get the data in the text field
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("subject_list")
                      .where('department', isEqualTo: snapshot.data!.docs.single['department']).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> subjectItems = [];
                      for (int i = 0; i < snapshot.data!.docs.single['subject'].length; i++) {
                        List snap = snapshot.data!.docs.single['subject'];
                        subjectItems.add(
                          DropdownMenuItem(
                            child: Text(snap[i].toString()),
                            value: "${snap[i].toString()}",
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
                                selectedSubject = subjectValue;
                              });
                            },
                            value: selectedSubject,
                            hint: new Text("Wähle dein Fach aus",),
                          ),
                        ],
                      );
                    }
                    throw Exception("");
                  }); // Show loading if text is null
            },
          ),
          new Container(
            child: Text(
              'Rolle',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10),
            child: DropdownButton(
                value: dropdownRolle,
                items: [
                  DropdownMenuItem(
                    child: Text("Nachhilfe erhalten"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Nachhilfe geben"),
                    value: 2,
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    dropdownRolle = (value) as int;
                    if(value == 2)
                    {
                      checkboxVisibilty = true;
                    }
                    else
                    {
                      checkboxVisibilty = false;
                    }
                  });
                },
                hint:Text("Select item")
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10),
            width: 300,
            child: TextFormField(
              controller: textcontroller,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nachname des Lehrers'
              ),
            ),
          ),
          Visibility(
            visible: checkboxVisibilty,
            child: Text(
              'Lernhilfe für folgende Jahrgänge:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
              ),
            ),
          ),
          Visibility(
              visible: checkboxVisibilty,
              child: Container(
                  width: 200,
                  child: CheckboxListTile(
                    activeColor: Colors.purple,
                    title: Text('1'),
                    onChanged: (value) => setState(() {
                      this.checkboxValue1 = value!;
                      if(checkboxValue1)
                      {
                        jahrgang += '1;';
                      }
                    }),
                    value: checkboxValue1,
                  )
              )
          ),
          Visibility(
              visible: checkboxVisibilty,
              child: Container(
                  width: 200,
                  child: CheckboxListTile(
                    activeColor: Colors.purple,
                    title: Text('2'),
                    onChanged: (value) => setState(() {
                      this.checkboxValue2 = value!;
                      if(checkboxValue2)
                      {
                        jahrgang += '2;';
                      }
                    }),
                    value: checkboxValue2,
                  )
              )
          ),
          Visibility(
              visible: checkboxVisibilty,
              child: Container(
                  width: 200,
                  child: CheckboxListTile(
                    activeColor: Colors.purple,
                    title: Text('3'),
                    onChanged: (value) => setState(() {
                      this.checkboxValue3 = value!;
                      if(checkboxValue3)
                      {
                        jahrgang += '3;';
                      }
                    }),
                    value: checkboxValue3,
                  )
              )
          ),
          Visibility(
              visible: checkboxVisibilty,
              child: Container(
                  width: 200,
                  child: CheckboxListTile(
                    activeColor: Colors.purple,
                    title: Text('4'),
                    onChanged: (value) => setState(() {
                      this.checkboxValue4 = value!;
                      if(checkboxValue4)
                      {
                        jahrgang += '4;';
                      }
                    }),
                    value: checkboxValue4,
                  )
              )
          ),
          new Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: Text('Speichern', style: TextStyle(fontSize: 20.0)),
              onPressed: () {
                saveData();
              },
            ),
          ),

        ]),
      ),
    ));
  }
  void saveData()
  {
    final ref = store.collection('users').doc(_auth.currentUser!.uid.toString());
    if(dropdownRolle == 1)
    {
      ref.set({
        'takePrivateLessons' : {
          selectedSubject : {
            'teacherName' : textcontroller.text
          }
        }
      },SetOptions(merge: true));
      jahrgang = '';
    }
    else{
      ref.set({
        'givePrivateLessons' : {
          selectedSubject : {
            'providedYears' : jahrgang,
            'teacherName' : textcontroller.text
          }
        }
      },SetOptions(merge: true));
      jahrgang = '';
    }
  }
}