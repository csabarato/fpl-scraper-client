import 'package:flutter/material.dart';
import 'package:fpl_scraper_client/screens/picks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy PL Stats',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: PicksScreen(leagueId: Uri.base.queryParameters['leagueId'])
    );
  }
}
