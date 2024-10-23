import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fpl_scraper_client/config/app_config.dart';

class ParticipantService {

  static Future<http.Response> fetchLeagueData(String leagueId) {
    final uri = Uri.parse('${AppConfig.fplScraperServiceUrl}/league/data/$leagueId');
    return http.get(uri);
  }

  static Future<http.Response> fetchPicks(List<String> participantIds) {

    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> reqBody = {"playerIds" : participantIds};

    final uri = Uri.parse('${AppConfig.fplScraperServiceUrl}/league/picks');
    return http.post(uri, headers: headers, body: json.encode(reqBody));
  }
}