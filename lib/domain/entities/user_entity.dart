import 'package:bums_ar/domain/entities/item_entity.dart';
import 'package:latlong2/latlong.dart';

class UserEntity {
  final int inventorySize;
  final List<InventoryItem> inventory;
  final LatLng position;
  final UserStats stats;
  final String id;
  UserEntity({
    required this.inventory,
    required this.inventorySize,
    required this.position,
    required this.stats,
    required this.id,
  });

  UserEntity copyWith({
    int? inventorySize,
    List<InventoryItem>? inventory,
    LatLng? position,
    UserStats? stats,
    String? id,
  }) {
    return UserEntity(
      inventorySize: inventorySize ?? this.inventorySize,
      inventory: inventory ?? this.inventory,
      position: position ?? this.position,
      stats: stats ?? this.stats,
      id: id ?? this.id,
    );
  }

  factory UserEntity.fromApi(Map map) {
    return UserEntity(
      inventory: [],
      inventorySize: 0,
      position: LatLng(
        map['position']['coordinates'][1],
        map['position']['coordinates'][0],
      ),
      stats: UserStats.fromApi(map['stats']),
      id: map['_id'],
    );
  }
}

class UserStats {
  final double heal;
  final double food;
  final double water;
  final int level;
  final int exp;

  UserStats({
    required this.exp,
    required this.food,
    required this.heal,
    required this.level,
    required this.water,
  });

  factory UserStats.fromApi(Map map) {
    return UserStats(
      exp: map['exp'],
      food: map['food'].toDouble(),
      heal: map['heal'].toDouble(),
      level: map['level'],
      water: map['water'].toDouble(),
    );
  }
}

class InventoryItem {
  final String id;
  final ItemEntity item;

  InventoryItem({required this.item, required this.id});

  factory InventoryItem.fromApi(Map map) {
    return InventoryItem(item: ItemEntity.fromApi(map['item']), id: map['_id']);
  }
}
