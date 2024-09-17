import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/screens/campaign_homepage.dart';
import 'package:frs/screens/campaign_registation.dart';
import 'package:frs/screens/homescreen.dart';
import 'package:frs/screens/login_screen.dart';
import 'package:frs/services/authentication/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: "./.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/homescreen': (context) => const Homescreen(),
        '/loginScreen': (context) => const SignInPage2(),
        '/campaignHomePage': (context) => const CampaignHomepage(),
        '/campaign_registration': (context) =>
            const CampaignRegistationScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
