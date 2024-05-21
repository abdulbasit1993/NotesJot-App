import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notesjot_app/src/utils/constants.dart';

class ApiService {
  final String apiBaseUrl = baseURL;

  Future<dynamic> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$apiBaseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }
}
