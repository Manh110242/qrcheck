import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcheck/qr_data.dart';
import 'package:qrcheck/screen/lisdata.dart';
import 'package:qrcheck/screen/noi_dung.dart';
import 'package:qrcheck/screen/web_view_sp.dart';
import 'package:qrcheck/server/server_api.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'my_body_home.dart';
import 'package:http/http.dart';
import 'package:device_info/device_info.dart';
import 'package:geolocator/geolocator.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data, body, namephone, idPhone, latitude, longitude;
  Future<List<QrData>> future;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    setUpTimedFetch();
    Server().getDataServer().then((value) {
      lvData = value.reversed.toList();
    });
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        future = Server().getDataServer();
      });
    });
  }

  void getData() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    namephone = androidInfo.model;
    idPhone = androidInfo.androidId;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  }

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
        actions: [IconButton(icon: Icon(Icons.add),onPressed: (){
          setState(() {
            setUpTimedFetch();
          });
        },)],
      ),
      body: MyBodyHome(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.qr_code_scanner,
          size: 35,
        ),
        backgroundColor: Colors.blue.shade900,
        onPressed: () async {
          String barcodeScanRes = await scanner.scan();
          // cài đặt tham số POST request
          String url = 'http://testqrcode.nanoweb.vn/api/app/code/get-code';

          if (barcodeScanRes.startsWith("http")) {
            if (barcodeScanRes.startsWith("http://testqrcode.nanoweb.vn")) {
              var data1 = barcodeScanRes.split("id=");
              print(data1[1]);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                            url: barcodeScanRes,
                          )));
              Map json = {
                'code': '${data1[1]}',
                'latlng': '$latitude,$longitude',
                'imei': '$idPhone',
                'device': '$namephone',
              };
              // tạo POST request
              Response response = await post(url, body: json);
              body = response.body;

            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                            url: barcodeScanRes,
                          )));
            }
          } else {
            Map json = {
              'code': '$barcodeScanRes',
              'latlng': '$latitude,$longitude',
              'imei': '$idPhone',
              'device': '$namephone',
            };
            // tạo POST request
            Response response = await post(url, body: json);
            body = response.body;

            if (body.startsWith("\"")) {
              const start = "\"";
              const end = "\"";
              final startIndex = body.indexOf(start);
              final endIndex = body.indexOf(end, startIndex + start.length);

              data = body.substring(startIndex + start.length, endIndex);
              print(data);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                            url: data,
                          )));


            } else {
              data = barcodeScanRes;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoiDung(
                            noidung: data,
                          )));
            }
          }
          setState(() {
            setUpTimedFetch();
            Server().getDataServer().then((value) {
              lvData = value.reversed.toList();
            });
          });
        },
      ),
    );
  }
}
