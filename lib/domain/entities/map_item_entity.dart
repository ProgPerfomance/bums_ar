import 'package:bums_ar/domain/entities/item_entity.dart';
import 'package:latlong2/latlong.dart';

class MapItemEntity {
  LatLng position;
  final String id;
  final String itemId;
  final ItemEntity item;

  MapItemEntity({
    required this.position,
    required this.id,
    required this.itemId,
    required this.item,
  });

  factory MapItemEntity.fromApi(Map map) {
    return MapItemEntity(
      item: ItemEntity.fromApi(map['item']),
      position: LatLng(
        map['location']['coordinates'][1],
        map['location']['coordinates'][0],
      ),
      id: map['_id'],
      itemId: map['item_id'],
    );
  }
}
