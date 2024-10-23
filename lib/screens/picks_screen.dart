import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpl_scraper_client/components/player_pick_card.dart';
import 'package:fpl_scraper_client/constants/strings.dart';
import 'package:fpl_scraper_client/models/player_model.dart';
import 'package:fpl_scraper_client/services/participant_service.dart';

class PicksScreen extends StatefulWidget {
  const PicksScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  State<PicksScreen> createState() => _PicksScreenState();
}

class _PicksScreenState extends State<PicksScreen> {
  String? leagueName;
  late Map<String, dynamic> participantsMap;
  late List<PlayerModel> playerList = [];
  late List<PlayerModel> filteredPlayerList = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    ParticipantService.fetchLeagueData(widget.leagueId).then((resp) {
      Map<String, dynamic> leagueDataMap =
          jsonDecode(utf8.decode(resp.bodyBytes));
      leagueName = leagueDataMap["leagueName"];
      participantsMap = leagueDataMap["participants"];
      ParticipantService.fetchPicks(participantsMap.keys.toList()).then((resp) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(resp.bodyBytes));
        for (Map<String, dynamic> element in json['picks']) {
          playerList.add(PlayerModel.fromJson(element));
        }
        filteredPlayerList = playerList;
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void filterPlayers(String query) {
    List<PlayerModel> tempList = [];
    if (query.isNotEmpty) {
      tempList = playerList
          .where((player) =>
              player.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      tempList = playerList;
    }
    setState(() {
      filteredPlayerList = tempList;
      searchQuery = query;
    });
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
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  leagueName ?? '',
                  style: const TextStyle(fontSize: 25.0),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: kSearchPlayersHint,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  filterPlayers(value);
                },
              ),
            ),
            // ListView for displaying players
            Expanded(
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 8.0,
                            strokeCap: StrokeCap.round,
                          )))
                  : ListView.builder(
                      itemCount: filteredPlayerList.length,
                      itemBuilder: (context, playerIndex) {
                        final player = filteredPlayerList[playerIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ExpansionTile(
                            shape: const Border.fromBorderSide(BorderSide(
                                color: Color.fromRGBO(56, 4, 60, 1),
                                width: 2.0)),
                            title: Text(player.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            textColor: Colors.black,
                            subtitle: Text(
                              'Picked by ${player.numOfPicks} players',
                            ),
                            children: [
                              SizedBox(
                                height: player.playerPicks.length * 60.0,
                                child: ListView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable scrolling within this ListView
                                  itemCount: player.playerPicks.length,
                                  itemBuilder: (context, pickIndex) {
                                    return PlayerPickCard(
                                      participantsMap[player
                                          .playerPicks[pickIndex]
                                          .participantId],
                                      player.playerPicks[pickIndex].multiplier,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
