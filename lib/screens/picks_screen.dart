import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:fpl_scraper_client/components/manager_captain_card.dart';
import 'package:fpl_scraper_client/components/player_pick_card.dart';
import 'package:fpl_scraper_client/constants/strings.dart';
import 'package:fpl_scraper_client/models/manager_captain_model.dart';
import 'package:fpl_scraper_client/models/player_model.dart';
import 'package:fpl_scraper_client/services/manager_service.dart';

class PicksScreen extends StatefulWidget {
  const PicksScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  State<PicksScreen> createState() => _PicksScreenState();
}

class _PicksScreenState extends State<PicksScreen> {
  String? leagueName;
  late Map<String, dynamic> managersMap;
  late List<ManagerCaptainModel> managerCaptainList = [];
  late List<PlayerModel> playerList = [];
  late List<PlayerModel> filteredPlayerList = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    ManagerService.fetchLeagueData(widget.leagueId).then((resp) {
      Map<String, dynamic> leagueDataMap =
          jsonDecode(utf8.decode(resp.bodyBytes));
      leagueName = leagueDataMap["leagueName"];
      managersMap = leagueDataMap["managers"];

      ManagerService.fetchPicks(managersMap.keys.toList()).then((resp) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(resp.bodyBytes));

        Map<String, dynamic> managerCapsMap =
            json['captainPicks'] as Map<String, dynamic>;
        for (MapEntry<String, dynamic> managerCapEntry
            in managerCapsMap.entries) {
          managerCaptainList.add(ManagerCaptainModel.fromJson(managerCapEntry));
        }

        for (Map<String, dynamic> element in json['picks']) {
          playerList.add(PlayerModel.fromJson(element));
        }
        filteredPlayerList = playerList;
        sortManagerNames();
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
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        leagueName ?? '',
                        style: const TextStyle(fontSize: 25.0),
                      ),
                    ),
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
                    // Captains List
                    isLoading
                        ? const SizedBox()
                        : ExpansionTile(
                            shape: const Border.fromBorderSide(
                              BorderSide(
                                color: Color.fromRGBO(56, 4, 60, 1),
                                width: 2.0,
                              ),
                            ),
                            title: const Text(
                              'Captains',
                              style: TextStyle(
                                  color: Color.fromRGBO(56, 4, 60, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: managersMap.length,
                                itemBuilder: (context, managerIndex) {
                                  String managerId =
                                      managerCaptainList[managerIndex]
                                          .managerId
                                          .toString();
                                  return ManagerCaptainCard(
                                    managersMap[managerId],
                                    managerCaptainList[managerIndex].playerName,
                                  );
                                },
                              ),
                            ],
                          ),
                    // Players List
                    isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 8.0,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredPlayerList.length,
                            itemBuilder: (context, playerIndex) {
                              final player = filteredPlayerList[playerIndex];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ExpansionTile(
                                  shape: const Border.fromBorderSide(
                                    BorderSide(
                                      color: Color.fromRGBO(56, 4, 60, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                  title: Text(
                                    player.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  textColor: Colors.black,
                                  subtitle: Text(
                                    'Picked by ${player.numOfPicks} players',
                                  ),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: player.playerPicks.length,
                                      itemBuilder: (context, pickIndex) {
                                        return PlayerPickCard(
                                          managersMap[player
                                              .playerPicks[pickIndex]
                                              .managerId],
                                          player.playerPicks[pickIndex]
                                              .multiplier,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sortManagerNames() {
    managerCaptainList.sort((a, b)  {
        String nameA = removeDiacritics(managersMap[a.managerId.toString()]);
        String nameB = removeDiacritics(managersMap[b.managerId.toString()]);
        return nameA.compareTo(nameB);
    });

    for (var playerData in playerList) {
      playerData.playerPicks.sort((a, b) {
        String nameA = removeDiacritics(managersMap[a.managerId.toString()]);
        String nameB = removeDiacritics(managersMap[b.managerId.toString()]);
        return nameA.compareTo(nameB);
      });
    }
  }
}
