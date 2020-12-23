import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:qrcheck/qr_data.dart';

class Server {

   Future<List<QrData>> getDataServer() async {

    String  url = 'http://testqrcode.nanoweb.vn/api/app/code/get-list';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    Map json = {
      'imei': '${androidInfo.id}',
    };
    try{
      final res = await http.post(url, body: json);
      if(res.statusCode == 200){
        final List<QrData> listdata  = qrDataFromJson(res.body);
        return listdata;
      }else{
        return List<QrData>();
      }
    }catch(e){
      return List<QrData>();
    }
  }

}
