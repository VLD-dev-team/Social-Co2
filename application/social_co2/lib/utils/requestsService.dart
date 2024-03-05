import 'dart:convert';
import 'package:http/http.dart' as http;

class requestService {
  // URL du serveur
  static const serverApiURL = 'https://social-co2.vld-group.com';

  // REQUETTE GET
  Future<Map<String, dynamic>> get(
      String endpoint, Map<String, String> headers) async {
    Map<String, dynamic> data = {};

    try {
      final response =
          await http.get(Uri.parse(serverApiURL + endpoint), headers: headers);
      data = json.decode(response.body);
    } catch (err) {
      data = {"error": "true", "error_message": err.toString()};
    }
    return data;
  }

  // REQUETTE POST
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, String> headers, Object body) async {
    Map<String, dynamic> data = {};

    try {
      final response = await http.post(Uri.parse(serverApiURL + endpoint),
          headers: headers, body: body);
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
      final response = await http.put(Uri.parse(serverApiURL + endpoint),
          headers: headers, body: body);
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
      final response = await http.delete(Uri.parse(serverApiURL + endpoint),
          headers: headers, body: body);
      data = json.decode(response.body);
    } catch (err) {
      data = {"error": true, "error_message": err.toString()};
    }
    return data;
  }
}
