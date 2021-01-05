import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:qrcheck/qr_data.dart';
import 'package:qrcheck/screen/lisdata.dart';

class Server {
  Future<List<QrData>> getDataServer() async {
    String url = 'http://testqrcode.nanoweb.vn/api/app/code/get-list';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String imei = androidInfo.androidId;
    //425e250c1d78491f
    Map json = {
      'imei': '425e250c1d78491f',
      'limit': '$limit',
      'page': '$page',
    };

    try {
      final res = await http.post(url, body: json);
      if (res.statusCode == 200) {
        final List<QrData> listdata = qrDataFromJson(res.body);
        return listdata;
      } else {
        return List<QrData>();
      }
    } catch (e) {
      return List<QrData>();
    }
  }
}
