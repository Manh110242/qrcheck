import 'dart:convert';

List<QrData> qrDataFromJson(String str) => List<QrData>.from(json.decode(str).map((x) => QrData.fromJson(x)));

String qrDataToJson(List<QrData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QrData {
  QrData({
    this.id,
    this.code,
    this.imei,
    this.device,
    this.latlng,
    this.city,
    this.country,
    this.createdAt,
    this.productId,
    this.supplierId,
    this.link,
  });

  String id;
  String code;
  String imei;
  String device;
  String latlng;
  String city;
  String country;
  String createdAt;
  String productId;
  String supplierId;
  String link;

  factory QrData.fromJson(Map<String, dynamic> json) => QrData(
    id: json["id"],
    code: json["code"],
    imei: json["imei"],
    device: json["device"],
    latlng: json["latlng"],
    city: json["city"],
    country: json["country"],
    createdAt: json["created_at"],
    productId: json["product_id"],
    supplierId: json["supplier_id"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "imei": imei,
    "device": device,
    "latlng": latlng,
    "city": city,
    "country": country,
    "created_at": createdAt,
    "product_id": productId,
    "supplier_id": supplierId,
    "link": link,
  };
}
