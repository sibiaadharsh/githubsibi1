import 'package:flutter/material.dart';
// import 'package:flutter_application_maps_api/homepage.dart';
import 'package:flutter_application_maps_api/mappage.dart';
// import 'package:flutter_application_maps_api/homepage.dart';
// import 'package:flutter_application_maps_api/mappage.dart';
// import 'package:flutter_application_maps_api/maptask.dart';
// import 'package:flutter_application_maps_api/homepage1.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
      ); 
  }
}
//AIzaSyD6pymvEp2UukkpredtDxBf1YdIfjBgOHI ->API Key
