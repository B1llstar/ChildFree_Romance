import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Utils/debug_utils.dart';

class HTTPService {
  Future<String> makeRequest(
      String property, String description, int maxTokens) async {
    final payload = {
      "user_input": 'Fill in a value for the property closest to: $property',
      "description": description,
      "temperature": .7,
      "maxTokens": maxTokens,
      "topP": .9,
      "topK": 0,
      "dialog": '',
      "history": '',
      "username": "User",
      "nickname": "User",
      "aiId": "Hai",
      "instruction": "Fill in a value for the given property."
    };

    http.Response? response;

    // This will respond with a string
    response = await http.post(
      Uri.parse('https://aianyone.net/api/v1/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
//        print('Response: ' + response.body.toString());
      String generatedText = response.body;
      DebugUtils.printDebug('Generated text: $generatedText');
      return generatedText;
    } else {
      return '';
    }
  }
}
