import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  String _baseCurrency = 'INR';

  set baseCurrency(String newVal) {
    _baseCurrency = newVal;
    notifyListeners();
  }

  String get baseCurrency => _baseCurrency;


  List<String> targetCurrencies = [];

  void addTarget(String newTarget) {
    if (!targetCurrencies.contains(newTarget)) {
      targetCurrencies.add(newTarget);
      notifyListeners();
    }
  }

  void removeTarget(String target) {
    if (targetCurrencies.contains(target)) {
      targetCurrencies.remove(target);
      notifyListeners();
    }
  }


}