import 'dart:convert';

import 'package:flutter/material.dart';
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
            print(element);
            playerList.add(PlayerModel.fromJson(element));
          }
          //print(playerList);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }


}
