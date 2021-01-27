import 'package:flutter/material.dart';
import 'package:qrcheck/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Check',
      home: HomePage(),
    );
  }
}


