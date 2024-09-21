import 'package:flutter/material.dart';
import 'package:fpl_scraper_client/screens/picks_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print('Firebase init failed $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy PL Stats',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:  const Color.fromRGBO(56,4,60,1)),
        useMaterial3: true,
      ),
      home: PicksScreen(leagueId: Uri.base.queryParameters['leagueId'])
    );
  }
}
