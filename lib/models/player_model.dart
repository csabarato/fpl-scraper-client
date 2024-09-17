import 'package:fpl_scraper_client/models/player_pick_model.dart';

class PlayerModel {

  final int playerId;
  final String name;
  final int numOfPicks;
  final List<PlayerPickModel> playerPicks;

  PlayerModel(this.playerId, this.name, this.numOfPicks, this.playerPicks);

  factory PlayerModel.fromJson(Map<String, dynamic> json) {

    List<dynamic> pickedByList = json['pickedBy'] as List<dynamic>;
    List<PlayerPickModel> picks = [];

    for (var pick in pickedByList) {
      picks.add(PlayerPickModel(pick['id'].toString(), pick['multiplier']));
    }

    return PlayerModel(json['playerId'], json['playerName'], json['numberOfPicks'], picks);
  }
  
}