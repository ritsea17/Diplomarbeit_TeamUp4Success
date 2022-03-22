import 'package:explore/widgets/TerminPage.dart';
import 'package:explore/widgets/web_scrollbar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';

class TerminErstellPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DropDown(),
      ),
    );
  }
}
class DropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {


  int dropdownGegenstand = 1;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;
  final priceTextcontroller = TextEditingController();
  final ortTextcontroller = TextEditingController();
  bool checkboxVisibilty = false;
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  var selectedPersonUid;
  var selectedPersonName;
  var selectedAbt;
  String jahrgang = '';
  var year;
  DateTime selectedDate = DateTime.now();
  TimeOfDay _startUhrzeit = TimeOfDay.now();
  late TimeOfDay _endUhrzeit = TimeOfDay.now();
  late TimeOfDay picked;
  late var classOfPerson;
  late var token;
  var UidName = '';

  Future<Null> selectStartTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: _startUhrzeit,
    ))!;
    setState(() {
      _startUhrzeit = picked;
    });
  }
  Future<Null> selectEndTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: _endUhrzeit,
    ))!;
    setState(() {
      _endUhrzeit = picked;
    });
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }
  _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  @override
  void initState()
  {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // To show Selected Item in Text.
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
              children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 80.0),
              child: Text(
                'Termin erstellen:',
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
              margin: const EdgeInsets.only(top: 40.0),
              padding: EdgeInsets.all(20),
              width: 800,
              child: Row(
                children: [
                  Text(
                    'Datum der Nachhilfestunde:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy').format( selectedDate),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text('Datum auswählen')
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.all(20),
              width: 600,
              child: Row(
                children: [
                  Text(
                    'Start der Nachhilfestunde:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(_startUhrzeit.toString().split('(').last.split(')').first, style: TextStyle(fontSize: 20)),
                  IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.alarm,
                      size: 20,
                    ),
                    onPressed: () {
                      selectStartTime(context);
                    },
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.all(20),
              width: 600,
              child: Row(
                children: [
                  Text(
                    'Ende der Nachhilfestunde:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(_endUhrzeit.toString().split('(').last.split(')').first, style: TextStyle(fontSize: 20)),
                  IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.alarm,
                      size: 20,
                    ),
                    onPressed: () {
                      selectEndTime(context);
                    },
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.all(20),
              width: 700,
              child: Row(
                children: [
                  Text(
                    'Name des anderen Schülers:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("users")
                          .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> subjectItems = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            subjectItems.add(
                              DropdownMenuItem(
                                child: Text(snap.get('display_name')),
                                value: "${snap.get('uid')}",
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
                                    selectedPersonUid = subjectValue;
                                  });
                                },
                                value: selectedPersonUid,
                                hint: new Text("Wähle aus!",),
                              ),
                            ],
                          );
                        }
                        throw Exception("Error");
                      }),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Ort:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  child: TextFormField(
                    controller: ortTextcontroller,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Ort eingeben'
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child:
                  Text(
                    'Preis:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  child: TextFormField(
                    controller: priceTextcontroller,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Preis eingeben'
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              margin: EdgeInsets.all(25),
              child: TextButton(
                child: Text('Speichern', style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  saveData();
                  showDialog(
                    context: context,
                    builder: (context) => TerminPage(),
                  );
                },
              ),
            ),
          ]),
        )
    )
    )
    ;
  }
  void saveData()
  {
    String token = _auth.currentUser!.uid +'|'+ selectedPersonUid.toString();
    final ref = store.collection('meeting');
    ref.add({
      'date': DateFormat('dd.MM.yyyy').format(selectedDate),
      'end_time' : _endUhrzeit.toString().split('(').last.split(')').first,
      'location' : ortTextcontroller.text,
      'price': priceTextcontroller.text,
      'start_time' : _startUhrzeit.toString().split('(').last.split(')').first,
      'token' : token.toString(),
    });
  }


}