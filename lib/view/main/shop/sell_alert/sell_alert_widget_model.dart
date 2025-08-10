import 'package:flutter/material.dart';

class SellAlertWidgetModel extends ChangeNotifier {
  int sellCount = 0;

  void addAll(int totalCount) {
    sellCount = totalCount;
    notifyListeners();
  }

  int totalSum(int sellPrice) {
    return sellPrice * sellCount;
  }

  void addOne(int totalCount) {
    if (sellCount < totalCount) {
      sellCount += 1;
      notifyListeners();
    }
  }

  void removeOne() {
    if (sellCount > 0) {
      sellCount -= 1;
      notifyListeners();
    }
  }

  void removeAll() {
    sellCount = 0;
    notifyListeners();
  }
}
