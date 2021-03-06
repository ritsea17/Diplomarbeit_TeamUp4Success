
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/utils/theme_data.dart';
import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
String email = '';
class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
    email = userEmail.toString();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Up 4 Success',
      theme: lightThemeData,
      debugShowCheckedModeBanner: false,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(),
    );
  }
}
