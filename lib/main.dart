import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobil_taxi/type1.dart';
import 'package:mobil_taxi/type2.dart';
import 'package:mobil_taxi/type3.dart';

import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Stop',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/": (context) => MainPage(),//MainPage(),
        "/type1": (context) => Type1(),
        "/type2":(context) => Type2(),
        "/type3":(context) => Type3(),
      },

    );
  }
}

