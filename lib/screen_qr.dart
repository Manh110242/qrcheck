import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'api_qrcode.dart';
import 'noi_dung.dart';
import 'webview_container.dart';

class ScreenQR extends StatefulWidget {
  @override
  _ScreenQRState createState() => _ScreenQRState();
}

class _ScreenQRState extends State<ScreenQR> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String namePhone, idPhone, lat, long;
  var bloc;
  var data;
  bool flash = false;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocaton();
    bloc = new ApiQrCode();
  }

  getQrCheck(String code) async {
    print(code + "abc");
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      namePhone = androidInfo.model;
      idPhone = androidInfo.id;
    });
    if (code.startsWith("http")) {
      if (code.startsWith("http://testqrcode.nanoweb.vn")) {
        var data1 = code.split("id=");
        print(data1[1]);
        var s1 = await bloc.postDataQr(
            data1[1].toString(), lat, long, idPhone, namePhone);
        print(s1);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      url: code,
                      title: "Nội dung mã",
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      url: code,
                      title: "Nội dung mã",
                    )));
      }
    } else {
      var dataqr =
          await bloc.postDataQr(code.toString(), lat, long, idPhone, namePhone);

      if (dataqr.startsWith("http")) {
        print(dataqr);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      url: dataqr,
                      title: "Nội dung mã",
                    )));
      } else {
        data = code;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoiDung(
                      noidung: data,
                    )));
      }
    }
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.6),
              ),
            )),
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 35,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        InkWell(
                          onTap: () {
                            print('nhap mã');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogQR(controller);
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white54,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.keyboard,
                                  color: Colors.white54,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Nhập mã bằng tay',
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              flash?Icons.flash_on:Icons.flash_off,
                              size: 35,
                              color: Colors.white54,
                            ),
                            onPressed: () async {
                             if(flash){
                               await controller?.toggleFlash();
                               setState(() {
                                 flash = !flash;
                               });
                             }else{
                               await controller?.toggleFlash();
                               setState(() {
                                 flash = !flash;
                               });
                             }
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Center(
                            child: Text(
                              result != null
                                  ? "Mã ${describeEnum(result.format)} : ${result.code}"
                                  : "Bạn hãy quét mã",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            if (result != null) {
                              await controller?.stopCamera();
                              getQrCheck(result.code.toString());
                            } else {
                              _scaffoldKey.currentState
                                  .showSnackBar(new SnackBar(
                                duration: Duration(seconds: 2),
                                content: new Text('Bạn chưa quét mã nào hết!'),
                                action: SnackBarAction(
                                  label: 'Đóng',
                                  onPressed: () {},
                                ),
                              ));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white54,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Xem Mã',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        print(scanData.code.toString());
        result = scanData;
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>NextPage(scanData.code.toString())));
      });
    });
  }

  Widget DialogQR(QRViewController controller) {
    return AlertDialog(
      title: Text("Nhập mã bằng tay"),
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: 'Nhập mã',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.keyboard,
            )),
      ),
      actions: [
        FlatButton(
            onPressed: () async {
              if (textEditingController != null &&
                  textEditingController.text != '') {
                await controller?.stopCamera();
                getQrCheck(result.code.toString());
              } else {
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  duration: Duration(seconds: 2),
                  content: new Text('Bạn chưa quét mã nào hết!'),
                  action: SnackBarAction(
                    label: 'Đóng',
                    onPressed: () {},
                  ),
                ));
              }
            },
            child: Text(
              'Xem mã',
              style: TextStyle(color: Colors.blue),
            )),
        FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(
              'Đóng',
              style: TextStyle(color: Colors.blue),
            )),
      ],
    );
  }
}
