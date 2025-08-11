import 'package:flutter/material.dart';

import '../../../../data/repository/shop_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../service_locator.dart';

class BuyItemViewModel extends ChangeNotifier {

  final ShopRepository _shopRepository = getIt.get<ShopRepository>();
  final UserRepository _userRepository = getIt.get<UserRepository>();

  int buyCount = 0;

  void addOne() {
    buyCount += 1;
    notifyListeners();
  }

  void add10() {
    buyCount += 10;
    notifyListeners();
  }

  void removeOne() {
    if(buyCount > 0) {
      buyCount -= 1;
      notifyListeners();
    }
  }

  void removeAll() {
    buyCount = 0;
    notifyListeners();
  }

  Future<void> buyItem (String shopId, String shopItemId) async {

    await _shopRepository.buyItemInShop(shopItemId, buyCount, _userRepository.activeUser.id, shopId);
    buyCount = 0;
    notifyListeners();
  }

}