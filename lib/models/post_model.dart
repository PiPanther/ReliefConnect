class PostModel {
  final String username;
  final String location;
  final String id;
  final String? thumbnail; // Optional
  final String shortText;
  final String pfp;
  final double latitude;
  final double longitude;
  final String pid;

  PostModel({
    required this.pid,
    required this.username,
    required this.location,
    required this.id,
    this.thumbnail,
    required this.shortText,
    required this.pfp,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'username': username,
      'location': location,
      'id': id,
      'thumbnail': thumbnail,
      'shortText': shortText,
      'pfp': pfp,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static PostModel fromMap(Map<String, dynamic> map) {
    return PostModel(
      pid: map['pid'],
      username: map['username'],
      location: map['location'],
      id: map['id'],
      thumbnail: map['thumbnail'],
      shortText: map['shortText'],
      pfp: map['pfp'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
