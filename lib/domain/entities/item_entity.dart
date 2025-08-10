class ItemEntity {
  final String name;
  final String description;
  final String imageUrl;
  final String id;
  final String rarity;

  ItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rarity,
  });

  factory ItemEntity.fromApi(Map map) {
    return ItemEntity(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      rarity: map['rarity'],
    );
  }
}
