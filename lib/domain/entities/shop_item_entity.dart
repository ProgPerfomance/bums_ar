import 'package:bums_ar/domain/entities/item_entity.dart';

class ShopItemEntity {
  final String id;
  final String shopId;
  final String itemId;
  final ItemEntity item;
  final int basePrice;
  final int sellPrice;
  final String status;
  final int? count;
  ShopItemEntity({
    required this.id,
    required this.item,
    required this.itemId,
    required this.count,
    required this.status,
    required this.basePrice,
    required this.sellPrice,
    required this.shopId,
  });

  factory ShopItemEntity.fromApi(Map map) {
    return ShopItemEntity(
      id: map['_id'],
      item: ItemEntity.fromApi(map['item']),
      itemId: map['item_id'],
      count: map['count'],
      status: map['status'],
      basePrice: map['base_price'],
      sellPrice: map['sell_price'],
      shopId: map['shop_id'],
    );
  }
}
