import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/items_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../service_locator.dart';

class InventoryViewmodel extends ChangeNotifier {


  final UserRepository _userRepository = getIt.get<UserRepository>();
  final ItemsRepository _itemsRepository = getIt.get<ItemsRepository>();

  List<InventoryItem> items = [];

  Future<void> getItems () async {

    items = await _userRepository.getUserInventory();
    notifyListeners();
  }

}