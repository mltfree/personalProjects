import 'package:flutter/material.dart';

import 'package:mobile_vision_test_v2/welcome_page.dart';
import 'package:mobile_vision_test_v2/qr_bar_code_detector.dart';
import 'package:mobile_vision_test_v2/text_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.teal[50],
      ),
      routes:{
        '/welcome': (context) => WelcomePage(),
        '/qrDetector' : (context) => QrBarDetector(),
        '/textReader' : (context) => TextReader(),

      },
      home: WelcomePage(),
    );
  }
}