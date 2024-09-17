import 'dart:convert';

import 'package:frs/constants/enums.dart';

class ComplaintModel {
  final String user_id;
  final String complaint_id;
  final double lattitude;
  final double longitude;
  final List<String> imgs;
  final EmergencyType emergencyType;
  final String description;
  final DateTime createdAt;
  final bool active;

  ComplaintModel(
      {required this.user_id,
      required this.complaint_id,
      required this.lattitude,
      required this.longitude,
      required this.imgs,
      required this.emergencyType,
      required this.description,
      required this.createdAt,
      required this.active});

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'user_id': user_id,
      'complaint_id': complaint_id,
      'lattitude': lattitude,
      'longitude': longitude,
      'imgs': imgs,
      'emergencyType': emergencyType.toString(),
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      active: map['active'],
      user_id: map['user_id'] ?? '',
      complaint_id: map['complaint_id'] ?? '',
      lattitude: map['lattitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      imgs: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWz9tftw9qculFH1gxieWkxL6rbRk_hrXTSg&s"
      ],
      // Return an empty list if imgs is null
      emergencyType: EmergencyType.values.firstWhere(
        (e) => e.toString() == map['emergencyType'],
        orElse: () => EmergencyType.other, // Default value if no match
      ),
      description: map['description'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplaintModel.fromJson(String source) =>
      ComplaintModel.fromMap(json.decode(source));
}
