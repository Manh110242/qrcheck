import 'package:flutter/material.dart';
import 'package:qrcheck/screen/lisdata.dart';
import 'package:qrcheck/qr_data.dart';
import 'package:intl/intl.dart';

class MyBodyHome extends StatefulWidget {
  @override
  _MyBodyHomeState createState() => _MyBodyHomeState();
}

class _MyBodyHomeState extends State<MyBodyHome> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (lvData == null || lvData.length ==0)
        ? Container(
            child: Center(
              child: Text(
                'Bạn chưa quét gì cả. Hay thử làm gì đó đi.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
          : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: lvData.length,
            itemBuilder: (BuildContext context, int index) {
              QrData qrData = lvData[index];
              int time = int.parse(qrData.createdAt)*1000;

              String ngay = DateFormat('dd/MM/yyyy', 'en_US')
                  .format(DateTime.fromMillisecondsSinceEpoch(time));
              String gio = DateFormat('HH: mm a', 'en_US')
                  .format(DateTime.fromMillisecondsSinceEpoch(time));
              return Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: Colors.blue,
                      ),
                      Text(
                        '  ${qrData.code}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Column(
                          children: [
                            Text(
                              '$gio',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$ngay',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
  }
}

