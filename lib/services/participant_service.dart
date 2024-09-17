import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fpl_scraper_client/config/app_config.dart';

class ParticipantService {

  static Future<http.Response> fetchParticipants(String leagueId) {
    final uri = Uri.parse('${AppConfig.fplScraperServiceUrl}/league/participants/411201');
    return http.get(uri);
  }

  static Future<http.Response> fetchPicks(int gameweek, List<String> participantIds) {

    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> reqBody = {"gameweek": gameweek, "playerIds" : participantIds};

    final uri = Uri.parse('${AppConfig.fplScraperServiceUrl}/league/picks');
    return http.post(uri, headers: headers, body: json.encode(reqBody));
  }
}