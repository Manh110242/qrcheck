import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qrcheck/model_qr.dart';


class ApiQrCode{
  List<ModelQR> list =[];
  StreamController _streamController = new StreamController<dynamic>();
  Stream get counterStream => _streamController.stream;

  //425e250c1d78491f

  getDataQr(String imei,String page) async {
   print(imei);
    String url = 'http://testqrcode.nanoweb.vn/api/app/code/get-list';
    Map<String, dynamic> req_body = new Map();
    req_body['imei']="425e250c1d78491f";
    req_body['page']="$page";
    req_body['limit']="20";

    try{
      var res = await http.post(url, body: req_body);
      if(res.statusCode == 200){
        if(res.body != null){
          if(json.decode(res.body)["code"] == 0){
            for(var data in json.decode(res.body)["data"]){
              var model = new ModelQR(
                id: data["id"],
                code: data["code"],
                imei: data["imei"],
                device: data["device"],
                latlng: data["latlng"],
                city: data["city"],
                country: data["country"],
                createdAt: data["created_at"],
                productId: data["product_id"],
                supplierId: data["supplier_id"],
                link: data["link"],
              );
              list.add(model);
            }
          }
        }
      }
    }catch(e){
      return null;
    }
    _streamController.sink.add(list);
  }

  postDataQr(String code,String lat, String long, String imei, String name) async {
    String url = 'http://testqrcode.nanoweb.vn/api/app/code/get-code';
    Map<String, String> req_body = new Map();
    req_body['code']="$code";
    req_body['latlng']="$lat,$long";
    req_body['imei']="$imei";
    req_body['device']="$name";
      var res = await http.post(url, body: req_body);
      var data = json.decode(res.body);
      print(res.body);
      return data.toString();

  }
}