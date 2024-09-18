import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpl_scraper_client/components/player_pick_card.dart';
import 'package:fpl_scraper_client/models/player_model.dart';
import 'package:fpl_scraper_client/services/participant_service.dart';

class PicksScreen extends StatefulWidget {
  const PicksScreen({super.key, this.leagueId});

  final String? leagueId;

  @override
  State<PicksScreen> createState() => _PicksScreenState();
}

class _PicksScreenState extends State<PicksScreen> {
  late Map<String, dynamic> participantsMap;
  late List<PlayerModel> playerList = [];

  @override
  void initState() {
    super.initState();

    if (widget.leagueId != null) {
      ParticipantService.fetchParticipants(widget.leagueId!).then((resp) {
        participantsMap = jsonDecode(utf8.decode(resp.bodyBytes));
        ParticipantService.fetchPicks(4, participantsMap.keys.toList())
            .then((resp) {
          Map<String, dynamic> json = jsonDecode(utf8.decode(resp.bodyBytes));
          for (Map<String, dynamic> element in json['picks']) {
            playerList.add(PlayerModel.fromJson(element));
          }
          print('loaded ${playerList.length} players');
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        body: ListView.builder(
            itemCount: playerList.length,
            itemBuilder: (context, playerIndex) {
              final player = playerList[playerIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ExpansionTile(
      
                  title: Text(player.name),
                  subtitle: Text('Picked by ${player.numOfPicks} players'),
                  children: [
                    SizedBox(
                      height: player.playerPicks.length * 60.0,
                      child: ListView.builder(
                          itemCount: player.playerPicks.length,
                          itemBuilder: (context, pickIndex) {
                            return PlayerPickCard(participantsMap[player.playerPicks[pickIndex].participantId], player.playerPicks[pickIndex].multiplier);
                          }),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
