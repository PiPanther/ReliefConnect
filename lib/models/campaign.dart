import 'dart:convert';

class Campaign {
  final String firmName;
  final String ownerName;
  final String address;
  final String gst;

  Campaign(
      {required this.firmName,
      required this.ownerName,
      required this.address,
      required this.gst});

  Map<String, dynamic> toMap() {
    return {
      'firmName': firmName,
      'ownerName': ownerName,
      'address': address,
      'gst': gst,
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      firmName: map['firmName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      address: map['address'] ?? '',
      gst: map['gst'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Campaign.fromJson(String source) =>
      Campaign.fromMap(json.decode(source));
}
