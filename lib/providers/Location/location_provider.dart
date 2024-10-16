import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

final locationPrvider = Provider((ref) => LocationService());
final addressProvider = Provider<String>((ref) => LocationService().location);

class LocationService {
  String location = "India";
  Future<Map<String, double>> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location Services Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }
    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best));
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }

  Future<String> getAddressFromCoordinates() async {
    Map<String, double> coord = await getCurrentLocation();
    print(coord);
    double? latitude = coord['latitude'];
    double? longitude = coord['longitude'];
    try {
      // Perform reverse geocoding
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);

      // Check if any placemarks were returned
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        location = '${place.street}, ${place.locality}, ${place.postalCode}';
        // Construct address string
        return '${place.locality}, ${place.postalCode}';
      } else {
        throw Exception('No address found for the given coordinates.');
      }
    } catch (e) {
      // Handle errors
      throw Exception('Error retrieving address: $e');
    }
  }
}
