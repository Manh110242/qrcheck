import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcheck/api_qrcode.dart';
import 'package:qrcheck/model_qr.dart';
import 'package:qrcheck/noi_dung.dart';
import 'package:qrcheck/webview_container.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String namePhone, idPhone, lat, long;
  ScrollController _sc = new ScrollController();
  var data;
  bool _loading;
  int page = 1;
  String imageurl = "https://yeudohoa.vn/wp-content/uploads/2018/08/4_WUZI.jpg";
  var bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new ApiQrCode();
    iosAndroid();
    getLocaton();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        setState(() {
          _loading = true;
          page++;
        });
        bloc.getDataQr(idPhone, "$page");
        Timer.periodic(Duration(milliseconds: 1500), (timer) {
          if (this.mounted) {
            setState(() {
              _loading = false;
            });
          }
        });
      }
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
    print(barcodeScanRes);
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      namePhone = androidInfo.model;
      idPhone = androidInfo.id;
    });
    if (barcodeScanRes.startsWith("http")) {
      if (barcodeScanRes.startsWith("http://testqrcode.nanoweb.vn")) {
        var data1 = barcodeScanRes.split("id=");
        print(data1[1]);
        var s1 = await bloc.postDataQr(
            data1[1].toString(), lat, long, idPhone, namePhone);
        print(s1);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      url: barcodeScanRes,
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      url: barcodeScanRes,
                    )));
      }
    } else {
      var dataqr = await bloc.postDataQr(
          barcodeScanRes.toString(), lat, long, idPhone, namePhone);

      if (dataqr.startsWith("http")) {
        print(dataqr);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      url: dataqr,
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

  iosAndroid() {
    if (Platform.isAndroid) {
      getAndroidDeviceInfo();
    } else if (Platform.isIOS) {
      getIosDeviceInfo();
    }
  }

  getAndroidDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      namePhone = androidInfo.model;
      idPhone = androidInfo.id;
    });
    await bloc.getDataQr(idPhone, "$page");
  }

  getIosDeviceInfo() async {
    IosDeviceInfo iosInfor = await deviceInfo.iosInfo;
    namePhone = iosInfor.model;
    idPhone = iosInfor.name;
  }

  getLocaton() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude.toString();
    long = position.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Icon(
            Icons.toc_sharp,
            color: Colors.blue,
            size: 40,
          ),
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
      body: MyBody(),
      drawer: MyDrawer(),
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
          } else if (Platform.isIOS) {
            if (status.isDisabled) {
              getPermissionIos();
            } else {
              getQrCheck();
            }
          }
        },
      ),
    );
  }

  Widget MyBody() {
    return StreamBuilder(
        stream: bloc.counterStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data.length > 0)
                ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    controller: _sc,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      ModelQR qrData = snapshot.data[index];
                      int time = int.parse(qrData.createdAt) * 1000;
                      String ngay = DateFormat('dd/MM/yyyy', 'en_US')
                          .format(DateTime.fromMillisecondsSinceEpoch(time));
                      String gio = DateFormat('HH: mm a', 'en_US')
                          .format(DateTime.fromMillisecondsSinceEpoch(time));
                      if (snapshot.data.length <= 19) {
                        return Container(
                          height: 60,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: ListTile(
                            onTap: () {
                              if (qrData.link == null) {
                                return false;
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewContainer(
                                              url: qrData.link,
                                            )));
                              }
                            },
                            leading: Icon(
                              Icons.qr_code_scanner,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '${qrData.code}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '$gio, $ngay',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      } else if (index == (snapshot.data.length - 1) &&
                          _loading == true) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 60,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: ListTile(
                            onTap: () {
                              if (qrData.link == null) {
                                return false;
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewContainer(
                                              url: qrData.link,
                                            )));
                              }
                            },
                            leading: Icon(
                              Icons.qr_code_scanner,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '${qrData.code}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '$gio, $ngay',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                    })
                : Container(
                    child: Center(
                      child: Text(
                        'Lịch sữ trống.',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget MyDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(imageurl),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(namePhone != null ? namePhone : "",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        overflow: TextOverflow.ellipsis),
                    Text(
                      idPhone != null ? idPhone : "",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(
                  Icons.phone_android_sharp,
                  color: Colors.blueAccent,
                ),
                title: Text('Lịch sữ'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.menu_book_sharp,
                  color: Colors.blueAccent,
                ),
                title: Text('Hướng dẫn sử dụng'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.blueAccent,
                ),
                title: Text('Điều khoản sử dụng'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.blueAccent,
                ),
                title: Text('Liên hệ & hỗ trợ'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
