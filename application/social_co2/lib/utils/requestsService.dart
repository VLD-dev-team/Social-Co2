import 'dart:convert';
import 'package:http/http.dart' as http;

class requestService {
  // URL du serveur
  static const String serverApiURL = 'https://api.social-co2.vld-group.com/';
  static const Map<String, String> additionnalHeaders = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin" : "app.social-co2.vld-group.com"
  };

  // REQUETTE GET
  Future<Map<String, dynamic>> get(
      String endpoint, Map<String, String> headers) async {
    Map<String, dynamic> data = {};

    try {
      final url = Uri.parse(serverApiURL + endpoint);
      headers.addAll(additionnalHeaders);

      final response = await http.get(url, headers: headers);
      data = json.decode(response.body);
    } catch (err) {
      data = {"error": true, "error_message": err.toString()};
    }
    return data;
  }

  // REQUETTE POST
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, String> headers, Object body) async {
    Map<String, dynamic> data = {};

    print(body);

    try {
      final url = Uri.parse(serverApiURL + endpoint);
      headers.addAll(additionnalHeaders);

      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      data = json.decode(response.body);
    } catch (err) {
      data = {"error": true, "error_message": err.toString()};
    }
    return data;
  }

  // REQUETTE PUT
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, String> headers, Object body) async {
    Map<String, dynamic> data = {};

    try {
      final url = Uri.parse(serverApiURL + endpoint);
      headers.addAll(additionnalHeaders);
      print(jsonEncode(headers));

      final response =
          await http.put(url, headers: headers, body: jsonEncode(body));
      print(response.toString());
      data = json.decode(response.body);
    } catch (err) {
      data = {"error": true, "error_message": err.toString()};
    }
    return data;
  }

  // REQUETTE DELETE
  Future<Map<String, dynamic>> delete(
      String endpoint, Map<String, String> headers, Object body) async {
    Map<String, dynamic> data = {};

    try {
      final url = Uri.parse(serverApiURL + endpoint);
      headers.addAll(additionnalHeaders);

      final response =
          await http.delete(url, headers: headers, body: jsonEncode(body));
      data = json.decode(response.body);
    } catch (err) {
      data = {"error": true, "error_message": err.toString()};
    }
    return data;
  }
}
