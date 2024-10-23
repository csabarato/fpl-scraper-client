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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
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
            const SizedBox(width: 20.0),
            RoundedButton(
              onPressed: getLeagueIdAndNavigateToPicks,
              text: kContinue,
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
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
