import 'package:latlong2/latlong.dart';

class ShopEntity {
  LatLng position;
  final String name;
  final String type;
  final String id;
  final String imageUrl;
  final String? backgroundImageUrl;
  ShopEntity({
    required this.id,
    required this.name,
    required this.position,
    required this.type,
    required this.imageUrl,
    this.backgroundImageUrl,
  });

  factory ShopEntity.fromApi(Map map) {
    print(map);
    return ShopEntity(
      id: map['_id'],
      name: map['name'],
      position: LatLng(
        map['location']['coordinates'][1],
        map['location']['coordinates'][0],
      ),
      type: map['type'],
      imageUrl: map['imageUrl'],
      backgroundImageUrl: map['backgroundImageUrl'],
    );
  }
}
