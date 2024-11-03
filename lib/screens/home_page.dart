import 'package:flutter/material.dart';
import 'package:fpl_scraper_client/components/rounded_button.dart';
import 'package:fpl_scraper_client/constants/strings.dart';
import 'package:fpl_scraper_client/screens/picks_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String? leagueId;

  @override
  void initState() {
    super.initState();
    var leagueId = Uri.base.queryParameters['leagueId'];
    if (leagueId != null && leagueId.isNotEmpty) {
      Future.microtask(() => {
            if (mounted)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PicksScreen(leagueId: leagueId)))
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(56, 4, 60, 1),
          title: const Text(kAppName),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 500,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: kLeagueIdTextInputHint,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            RoundedButton(
              onPressed: getLeagueIdAndNavigateToPicks,
              text: kContinue,
            ),
            SizedBox(
                height: 50,
                child: leagueId == kNoLeagueId
                    ? const Center(
                        child: Text(
                        kNoLeagueCodeFoundMessage,
                        style: TextStyle(fontSize: 20, color: Colors.redAccent),
                      ))
                    : const Text('')),
            const Text(
              'How to find my League ID?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '1. Go to Leagues & Cups tab on Fantasy PL site.\n'
              '2. Select your preferred league\n'
              '3. Copy & paste the URL from your browser.',
              style: TextStyle(fontSize: 15.0, height: 2.5),
            ),
          ],
        ),
      ),
    );
  }

  // Function to extract the league id from the link
  void getLeagueIdAndNavigateToPicks() {
    String inputStr = _controller.text.trim();

    if (RegExp(r'^\d+$').hasMatch(inputStr)) {
      leagueId = inputStr; // Input is directly the league code
      navigateToPicksScreen(leagueId!);
      return;
    }

    RegExp regExp = RegExp(r'leagues\/(\d+)');
    Match? match = regExp.firstMatch(inputStr);
    if (match != null) {
      leagueId = match.group(1);
      navigateToPicksScreen(leagueId!);
    } else {
      setState(() {
        leagueId = kNoLeagueId;
      });
    }
  }

  void navigateToPicksScreen(String leagueCode) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PicksScreen(
                  leagueId: leagueId!,
                )));
  }
}
