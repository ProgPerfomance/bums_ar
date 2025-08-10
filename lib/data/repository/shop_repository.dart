import 'package:bums_ar/core/services/remote_service.dart';
import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:bums_ar/domain/entities/shop_item_entity.dart';

class ShopRepository {

  Future<List<ShopEntity>> getOfflineShops (double lat, double long) async {

    final response = await RemoteService.getMapShops(lat, long);

    List data = response.data;

    return data.map((v)=> ShopEntity.fromApi(v)).toList();

  }

  Future<List<ShopItemEntity>> getShopItems (String shopId) async {

    final response = await RemoteService.getShopItems(shopId);
    List data = response.data;

    return data.map((v)=> ShopItemEntity.fromApi(v)).toList();
  }

}