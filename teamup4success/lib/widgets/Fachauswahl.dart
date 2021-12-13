import 'package:explore/widgets/web_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:explore/widgets/explore_drawer.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:explore/widgets/top_bar_contents.dart';

class FachauswahlPage extends StatefulWidget {

  @override
  _FachauswahlState createState() => _FachauswahlState();
}

class _FachauswahlState extends State<FachauswahlPage>
{
  int dropdownGegenstand = 1;
  int dropdownRolle = 1;
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

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
                new Container(
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
                  margin: const EdgeInsets.only(top: 40.0),
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
                new Container(
                  padding: EdgeInsets.all(20),
                  child: DropdownButton(
                      value: dropdownGegenstand,
                      items: [
                        DropdownMenuItem(
                          child: Text("Deutsch"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Englisch"),
                          value: 2,
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropdownGegenstand = (value) as int;
                        });
                      },
                      hint:Text("Select item")
                  ),
                ),
                new Container(
                  child: Text(
                    'Rolle:',
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
                  padding: EdgeInsets.all(20),
                  child: DropdownButton(
                      value: dropdownRolle,
                      items: [
                        DropdownMenuItem(
                          child: Text("Schüler"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Lehrer"),
                          value: 2,
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropdownRolle = (value) as int;
                        });
                      },
                      hint:Text("Select item")
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(25),
                  child: TextButton(
                    child: Text('Speichern', style: TextStyle(fontSize: 20.0)),
                    onPressed: () {},
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
