import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcheck/marquee_widget.dart';
import 'package:qrcheck/screen_qr.dart';

class Home extends StatefulWidget {
  String name;

  Home({this.name});

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 90,
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: ExactAssetImage(
                                              'assets/images/defaultImageProfile.png'),
                                          fit: BoxFit.cover)),
                                  width: 60,
                                  height: 60,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Xin chào,", style: TextStyle(fontSize: 13, color: Colors.grey.shade700),),
                                    widget.name != null
                                        ? Container(
                                            width: 70,
                                            child: MarqueeWidget(
                                                direction: Axis.horizontal,
                                                child: Text(
                                                  widget.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )))
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              color: Colors.grey.shade300,
                              height: 1,
                              width: 120,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await Permission.camera.request();
                          var status = await Permission.locationWhenInUse.serviceStatus;
                          if(status.isDisabled){
                            getPermissionAndroid();
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenQR()));
                          }
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green,),
                          child: Center(child: Icon(Icons.qr_code_scanner, color: Colors.white,size: 60,)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.grey.shade300,
                            height: 1,
                            width: 120,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 40,
                          ),
                          Text('Quà của tôi',style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: 40,
                          ),
                          Text('Sự kiên',style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 40,
                          ),
                          Text('Danh muc',style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){},
                  child: Column(
                    children: [
                      Icon(Icons.card_giftcard, color: Colors.white,size: 40,),
                      Text('Quà của tôi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, color: Colors.white,size: 40,),
                      Text('Điểm tích lũy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Column(
                    children: [
                      Icon(Icons.ballot_outlined, color: Colors.white,size: 40,),
                      Text('Đặt hàng', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Column(
                    children: [
                      Icon(Icons.notifications_active_outlined, color: Colors.white,size: 40,),
                      Text('Thông báo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
