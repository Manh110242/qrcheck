import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrcheck/api_qrcode.dart';
import 'package:qrcheck/model_qr.dart';
import 'package:qrcheck/webview_container.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var bloc;
  ScrollController _sc = new ScrollController();
  bool _loading;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String namePhone, idPhone, lat, long;
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new ApiQrCode();
    getAndroidDeviceInfo();
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
  getAndroidDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      namePhone = androidInfo.model;
      idPhone = androidInfo.id;
    });
    await bloc.getDataQr(idPhone, "$page");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
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
                            color: Colors.white60),
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
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
                            ),
                            ),
                          ),
                      );
                    } else {
                      return Container(
                        height: 60,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white60),
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
                                        title: 'Nội dung mã',
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
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              );
            }
          }),
    );
  }
}
