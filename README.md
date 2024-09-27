# FRS - Flutter Relief System

## Project Overview

FRS is a Flutter application designed to connect people in need of emergency assistance with relevant resources and support. It serves as a platform to:

- **Seek Help:** Users can quickly find and contact emergency services, such as police, fire, and ambulance, based on their location.
- **Report Incidents:** Report incidents and emergencies to relevant authorities, including details and location information.
- **Donate:** Contribute to relief campaigns and organizations to support disaster relief efforts.
- **Track Campaigns:** Follow the progress of relief campaigns and stay informed about the impact of donations.

## Features

- **Location-Based Services:**  Leverages device location to provide emergency contact information and incident reporting.
- **Emergency Contact Directory:**  Provides quick access to emergency services based on user location.
- **Incident Reporting:** Allows users to report emergencies with detailed information and location data.
- **Donation Feature:** Integrates with payment gateways to enable users to contribute to relief campaigns.
- **Campaign Tracking:** Displays information about active relief campaigns and the impact of donations.
- **User Authentication:** Enables user accounts for personalized experience and donation management.
- **Social Media Integration:** Option to share emergency reports or campaign information on social media.
- **Sharing Post Functions:** Imtegration for sharing posts and view all the posts in a specified range.


## Installation

### Prerequisites

- Flutter:  [https://flutter.dev/](https://flutter.dev/)
- Dart: Flutter uses Dart, which is included with Flutter.
- Android Studio (for Android development)
- Xcode (for iOS development)

### Installation Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/FRS.git
   ```

2. **Navigate to the Project Directory:**
   ```bash
   cd FRS
   ```

3. **Set up Flutter Environment:**
   ```bash
   flutter doctor
   ```
   If any dependencies are missing, follow the instructions provided by `flutter doctor` to install them.

4. **Get Dependencies:**
   ```bash
   flutter pub get
   ```

## Usage

### Running the App

1. **Android:**
   ```bash
   flutter run -d <device_id>
   ```
   Replace `<device_id>` with the device ID of your connected Android device.

2. **iOS:**
   ```bash
   flutter run -d <device_id>
   ```
   Replace `<device_id>` with the device ID of your connected iOS device.

3. **Web:**
   ```bash
   flutter run -d web
   ```

### App Navigation

- **Homepage:**  The main screen provides access to emergency services, campaign details, and user login.
- **Seek Help:** Allows users to select their location and view relevant emergency contact information.
- **Report Incident:** Allows users to report emergencies with details and location data.
- **Donate:**  Navigates to the donation screen to contribute to relief campaigns.
- **Campaign Homepage:**  Displays information about active relief campaigns.
- **Campaign Registration:**  Allows users to register new relief campaigns.
- **Login Screen:** Enables users to log in or create an account.
- **Payment Screen:** Processes user donations.

### Code Examples

- **Accessing User Location:**
   ```dart
   import 'package:geolocator/geolocator.dart';

   // ...

   Position position = await Geolocator.getCurrentPosition();
   double latitude = position.latitude;
   double longitude = position.longitude;
   ```

## License

The FRS project is licensed under the MIT License. 

## Contact Information

- **Email:** your-email@example.com
- **Website:** your-website.com

## Contributing

Contributions to the FRS project are welcome! Please submit a pull request with any changes or enhancements you'd like to make.

## Acknowledgments

This project utilizes the following third-party packages:

- Flutter
- Dart
- Geolocator
- Firestore
- Firebase Auth
- Firebase Core
- Firebase Storage
- fluttertoast
- flutter_phone_dialer
- flutter_plugin_android_lifecycle
- path_provider
- razorpay_flutter
- vibration
- webview_flutter
- easy_upi_payment
- image_picker_android
- geocoding
- google_sign_in

The project is also inspired by various open-source projects and resources. 
