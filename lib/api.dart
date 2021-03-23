import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

var baseUrl = Uri.parse(
    "https://api.nasa.gov/planetary/apod?api_key=aWPhODExHc5j48m59viPzCysv1jkoaN7ID2dchPw&date=2017-07-10");
Future<LatestNewsResponse> createLatestNewsResponseState(context) async {
  final http.Response response = await http.get(baseUrl);

  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    print(data);
    Provider.of<LatestNewsResponse>(context, listen: false)
        .addLatestNewsResponse(response, data);
    return LatestNewsResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class LatestNewsResponse with ChangeNotifier {
  dynamic response;
  dynamic data;

  LatestNewsResponse({
    this.response,
    this.data,
  });

  LatestNewsResponse.fromJson(Map<String, dynamic> json) {
    // response = json['response'];
    data = json;
    notifyListeners();
  }

  void addLatestNewsResponse(response, data) {
    this.response = response;
    this.data = data;
    notifyListeners();
  }
}
