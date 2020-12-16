import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoiDung extends StatefulWidget {
  String noidung;

  NoiDung({this.noidung});

  @override
  _NoiDungState createState() => _NoiDungState();
}

class _NoiDungState extends State<NoiDung> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nội Dung'),
        ),
        body: Container(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  widget.noidung,
                  style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Nội Dung mã code trên không phải do chúng tôi phát hành vui lòng kiểm tra lại ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
