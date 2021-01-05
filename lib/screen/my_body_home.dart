import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcheck/screen/lisdata.dart';
import 'package:qrcheck/qr_data.dart';
import 'package:intl/intl.dart';
import 'package:qrcheck/server/server_api.dart';
import 'web_view_sp.dart';

class MyBodyHome extends StatefulWidget {
  @override
  _MyBodyHomeState createState() => _MyBodyHomeState();
}

class _MyBodyHomeState extends State<MyBodyHome> {
  ScrollController _sc = new ScrollController();

  Future<List<QrData>> future;
  Timer timer;
  int _page = 20;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _page += 20;
        limit = _page;
        Server().getDataServer().then((value) {
          lvData = value;
        });
       setState(() {
         _loading = true;
       });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (lvData == null || lvData.length == 0)
        ? Container(
            child: Center(
              child: Text(
                'Lịch sữ trống.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            controller: _sc,
            itemCount: lvData.length,
            itemBuilder: (BuildContext context, int index) {
              QrData qrData = lvData[index];
              int time = int.parse(qrData.createdAt) * 1000;
              String ngay = DateFormat('dd/MM/yyyy', 'en_US')
                  .format(DateTime.fromMillisecondsSinceEpoch(time));
              String gio = DateFormat('HH: mm a', 'en_US')
                  .format(DateTime.fromMillisecondsSinceEpoch(time));
              if (lvData.length <= 19) {
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
              } else {
                if (index == (lvData.length - 1) && _loading == true) {
                  Timer.periodic(Duration(milliseconds: 2000), (timer) {
                    setState(() {
                      _loading = false;
                    });
                  });
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
              }
            });
  }
}

