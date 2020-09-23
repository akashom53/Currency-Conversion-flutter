import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = "api.exchangeratesapi.io";
const endPoint = "/latest";

class ConversionManager extends ChangeNotifier {
  Map<String, double> rates = {};
  bool inProgress = false;

  Future<bool> fetchRates(String base, List<String> targets) async {
    inProgress = true;
    notifyListeners();
    final uri = Uri.https(baseUrl, endPoint, {
      'base': base,
      'symbols': targets.join(','),
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return false;
    final jsonResp = json.decode(response.body);
    final newRates = jsonResp['rates'];
    rates = {};
    for (var key in newRates.keys) {
      rates[key] = newRates[key];
    }
    inProgress = false;
    notifyListeners();
    return true;
  }

  void notify() {
    notifyListeners();
  }

  Map<String, double> values(double base) =>
      rates.map((curr, rate) => MapEntry(curr, rate * base));
}
