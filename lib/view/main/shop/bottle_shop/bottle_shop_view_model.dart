import 'package:bums_ar/data/repository/shop_repository.dart';
import 'package:bums_ar/domain/entities/item_entity.dart';
import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:bums_ar/domain/entities/shop_item_entity.dart';
import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view.dart';
import 'package:flutter/material.dart';

import '../../../../data/repository/items_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../service_locator.dart';
import '../sell_alert/sell_alert_widget.dart';

class BottleShopViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();
  final ItemsRepository _itemsRepository = getIt.get<ItemsRepository>();
  final ShopRepository _shopRepository = getIt.get<ShopRepository>();

  List<ShopItemEntity> items = [];
  List<InventoryItem> userItems = [];
  bool isLoading = false;

  Future<void> initShopData(String shopId) async {
    isLoading = true;
    notifyListeners();
    userItems = await _userRepository.getUserInventory();
    items = await _shopRepository.getShopItems(shopId);
    print(items);

    isLoading = false;
    notifyListeners();
  }

  Widget? sellSheet;

  setSellSheet (ShopItemEntity shopItem, ShopEntity shop, int itemCount) {
    sellSheet = SellAlert(shopItem: shopItem, shop: shop, maxCount: itemCount, vmCallback: initShopData,);
    notifyListeners();
  }

  closeSellSheet() {
    sellSheet = null;
    notifyListeners();
  }

}
