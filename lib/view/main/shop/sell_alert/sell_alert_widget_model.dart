import 'package:bums_ar/core/services/app_money_notificaions.dart';
import 'package:bums_ar/data/repository/shop_repository.dart';
import 'package:bums_ar/data/repository/user_repository.dart';
import 'package:bums_ar/service_locator.dart';
import 'package:flutter/material.dart';

class SellAlertWidgetModel extends ChangeNotifier {
  int sellCount = 0;

  final ShopRepository _shopRepository = getIt.get<ShopRepository>();
  final UserRepository _userRepository = getIt.get<UserRepository>();

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

  Future<void> sellItems(String itemId, String shopId, int itemPrice) async {
    DeltaOverlay.instance.money(itemPrice * sellCount);
    await _shopRepository.sellItemInShop(
      itemId,
      sellCount,
      shopId,
      _userRepository.activeUser.id,
      itemPrice,
    );
    sellCount = 0;
    _userRepository.getUserById(_userRepository.activeUser.id);
    notifyListeners();
  }
}
