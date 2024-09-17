import 'dart:convert';

class DonationTaker {
  final String id;
  final String upi;
  final String firmName;
  final String firmAddress;
  final String ownerName;
  final String pan;
  final String gst;
  final double donationAmount;
  final String thumbnail; // Thumbnail URL
  final List<String> imageUrls; // List of image URLs
  final List<Map<String, String>> donationsBy;

  DonationTaker(
      {required this.firmName,
      required this.id,
      required this.upi,
      required this.firmAddress,
      required this.ownerName,
      required this.pan,
      required this.donationAmount,
      required this.donationsBy,
      required this.gst,
      required this.thumbnail,
      required this.imageUrls});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'upi': upi,
      'firmName': firmName,
      'firmAddress': firmAddress,
      'ownerName': ownerName,
      'pan': pan,
      'donationAmount': donationAmount,
      'donationsBy': donationsBy,
      'gst': gst,
      'thumbnail': thumbnail,
      'imageUrls': imageUrls,
    };
  }

  factory DonationTaker.fromMap(Map<String, dynamic> map) {
    return DonationTaker(
      id: map['id'],
      upi: map['upi'],
      gst: map['gst'],
      firmName: map['firmName'] ?? '',
      firmAddress: map['firmAddress'] ?? '',
      ownerName: map['ownerName'] ?? '',
      pan: map['pan'] ?? '',
      donationAmount: (map['donationAmount'] ?? 0.0).toDouble(),
      donationsBy: List<Map<String, String>>.from(
          map['donationsBy']?.map((x) => Map<String, String>.from(x)) ?? []),
      thumbnail: map['thumbnail'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory DonationTaker.fromJson(String source) =>
      DonationTaker.fromMap(json.decode(source));
}
