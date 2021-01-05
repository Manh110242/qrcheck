import 'dart:async';
import 'dart:io' show Platform;
import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:imei_plugin/imei_plugin.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data, body, namephone, idPhone, latitude, longitude;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Future<List<QrData>> future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iosAndroid();
    getLocaton();
    setUpTimedFetch();
    Server().getDataServer().then((value) {
      lvData = value;
    });
  }

  getPermissionAndroid() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bạn đã tắt GPS"),
            content: const Text(
                'Ứng dụng cần sữ dụng GPS để xác định vị trí. Hãy bật lên để có thể sữ dụng'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Đồng ý'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
              FlatButton(
                  child: Text('Thoát'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }),
            ],
          );
        });
  }
  getQrCheck() async {
    String barcodeScanRes = await scanner.scan();
    // cài đặt tham số POST request
    print(barcodeScanRes.runtimeType);
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
        lvData = value;
      });
    });
  }
  getPermissionIos() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bạn đã tắt GPS"),
            content: const Text(
                'Ứng dụng cần sữ dụng GPS để xác định vị trí. Hãy bật lên để có thể sữ dụng'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Đồng ý'),
                  onPressed: () {
                    AppSettings.openLocationSettings();
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
              FlatButton(
                  child: Text('Thoát'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }),
            ],
          );
        });
  }
  iosAndroid(){
    if(Platform.isAndroid){
      getAndroidDeviceInfo();
    }else if(Platform.isIOS){
      getIosDeviceInfo();
    }
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        future = Server().getDataServer();
      });
    });
  }

  getAndroidDeviceInfo() async {

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    namephone = androidInfo.model;
    idPhone = androidInfo.androidId;
  }

  getIosDeviceInfo() async {
    IosDeviceInfo iosInfor = await deviceInfo.iosInfo;
    namephone = iosInfor.model;
    idPhone = iosInfor.name;
  }

  getLocaton() async {
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
      ),
      body: MyBodyHome(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.qr_code_scanner,
          size: 35,
        ),
        backgroundColor: Colors.blue.shade900,
        onPressed: () async {                           
          var status = await Permission.locationWhenInUse.serviceStatus;
          if (Platform.isAndroid) {
            if (status.isDisabled) {
              getPermissionAndroid();
            } else {
              getQrCheck();
            }
          }else if(Platform.isIOS){
            if(status.isDisabled){
              getPermissionIos();
            }
            else{
              getQrCheck();
            }
          }
        },
      ),
    );
  }
}
