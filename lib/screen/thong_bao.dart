import 'package:flutter/material.dart';

class ThongBao extends StatefulWidget {

  @override
  _ThongBaoState createState() => _ThongBaoState();
}

class _ThongBaoState extends State<ThongBao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.qr_code_outlined,
            color: Colors.blue,
            size: 40,
          ),
          title: Text(
            "QR Check",
            style: TextStyle(
              color: Colors.blue.shade600,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Bạn đã quét quá nhiều lần. Chúng tôi nghi ngờ bạn gian lận',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
