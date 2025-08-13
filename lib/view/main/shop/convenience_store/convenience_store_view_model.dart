import 'package:flutter/material.dart';

import '../../../../data/repository/items_repository.dart';
import '../../../../data/repository/shop_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../domain/entities/shop_item_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../service_locator.dart';

class ConvenienceStoreViewModel extends ChangeNotifier {

  final UserRepository _userRepository = getIt.get<UserRepository>();
  final ItemsRepository _itemsRepository = getIt.get<ItemsRepository>();
  final ShopRepository _shopRepository = getIt.get<ShopRepository>();
  UserEntity get user => _userRepository.activeUser;
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


}