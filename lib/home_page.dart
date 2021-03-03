import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcheck/api_qrcode.dart';
import 'package:qrcheck/dieu_khoan_su_dung.dart';
import 'package:qrcheck/history.dart';
import 'package:qrcheck/home.dart';
import 'package:qrcheck/screen_details_code.dart';
import 'package:qrcheck/lienhe.dart';
import 'package:qrcheck/model_qr.dart';
import 'package:qrcheck/noi_dung.dart';
import 'package:qrcheck/screen_qr.dart';
import 'package:qrcheck/webview_container.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String namePhone, idPhone, lat, long;
  var data;
  bool _loading;
  int page = 1;
  String imageurl = "assets/images/defaultImageProfile.png";
  var bloc;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new ApiQrCode();
    iosAndroid();
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

  CheckPage(){
    if(index == 0 ){
      return Home(name: namePhone,);
    }if(index == 1){
      return History();
    }else{
      return Home(name: namePhone,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Icon(
            Icons.toc_sharp,
            color: Colors.white,
            size: 40,
          ),
        ),
        title: Text(
          "QR Check",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CheckPage(),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (value){
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), title: Text('Trang chủ')),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), title: Text('Lịch sử')),
        ],
      ),
    );
  }
  Widget MyDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
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
                              image: ExactAssetImage(imageurl),
                              fit: BoxFit.cover
                          )
                      ),

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
            ConfigurableExpansionTile(
              animatedWidgetFollowingHeader: const Icon(
                Icons.expand_more,
                color: const Color(0xFF707070),
              ),
                header: Text("Manh dep trai"),
              children: [
                ListTile(title: Text("manh 12314"),),
                ListTile(title: Text("manh 12314"),),
                ListTile(title: Text("manh 12314"),),
                ListTile(title: Text("manh 12314"),),
              ],
            ),
            InkWell(
              onTap: () {
               // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenDetailsCode()));
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewContainer(url: 'http://testqrcode.nanoweb.vn/about/hdsd',title: 'Hướng dẫn sử dụng',)));
              },
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewContainer(title: "Điều khoản sử dụng",url: "http://testqrcode.nanoweb.vn/about/privacy",)));
              },
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LienHe()));
              },
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
// var status = await Permission.locationWhenInUse.serviceStatus;
//           if (Platform.isAndroid) {
//             if (status.isDisabled) {
//               getPermissionAndroid();
//             } else {
//               getQrCheck();
//             }
//           } else if (Platform.isIOS) {
//             if (status.isDisabled) {
//               getPermissionIos();
//             } else {
//               getQrCheck();
//             }
//           }

// floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.qr_code_scanner,
//           size: 35,
//         ),
//         backgroundColor: Colors.blue.shade900,
//         onPressed: () async {
//           await Permission.camera.request();
//           var status = await Permission.locationWhenInUse.serviceStatus;
//           if(status.isDisabled){
//             getPermissionAndroid();
//           }else{
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenQR()));
//           }
//
//         },
//       ),