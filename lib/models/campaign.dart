import 'dart:convert';

class Campaign {
  final String firmName;
  final String ownerName;
  final String address;
  final String gst;
  final String thumbnail;
  final String id;
  final String upi;

  Campaign(
      {required this.firmName,
      required this.upi,
      required this.id,
      required this.thumbnail,
      required this.ownerName,
      required this.address,
      required this.gst});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'firmName': firmName,
      'ownerName': ownerName,
      'firmAddress': address,
      'gst': gst,
      'upi': upi,
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      id: map['id'],
      thumbnail: map['thumbnail'] ?? "",
      firmName: map['firmName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      address: map['firmAddress'] ?? '',
      gst: map['gst'] ?? '',
      upi: map['upi'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Campaign.fromJson(String source) =>
      Campaign.fromMap(json.decode(source));
}
