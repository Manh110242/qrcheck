import 'package:flutter/material.dart';

class LienHe extends StatefulWidget {
  @override
  _LienHeState createState() => _LienHeState();
}

class _LienHeState extends State<LienHe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Liên hệ & hỗ trợ',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.phone, color: Colors.blueAccent,),
                title: Text('Tổng đài hỗ trợ khách hàng'),
                subtitle: Text('0902195488'),
              ),
              ListTile(
                leading: Icon(Icons.mail_outline, color: Colors.blueAccent,),
                title: Text('Bộ phận chăm sóc khách hàng khác hàng'),
                subtitle: Text('cskh@qrcheck.vn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
