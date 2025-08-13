class NpcEntity {
  String name;
  int level;
  int baseHeal;
  RewardEntity reward;
  NpcEntity({
    required this.name,
    required this.level,
    required this.baseHeal,
    required this.reward,
  });

  factory NpcEntity.fromApi(Map map) {
    return NpcEntity(
      name: map['name'],
      level: map['level'],
      baseHeal: map['base_heal'],
      reward: RewardEntity.fromApi(map['reward']),
    );
  }
}

class RewardEntity {
  List<RewardItemEntity> items;
  int rub;
  int exp;
  RewardEntity({required this.items, required this.rub, required this.exp});

  factory RewardEntity.fromApi(Map map) {
    return RewardEntity(
      items: List.generate(map['items'].length, (index) {
        return RewardItemEntity.fromApi(map['items'][index]);
      }),
      rub: map['money']['rub'],
      exp: map['exp'],
    );
  }
}

class RewardItemEntity {
  final int itemCount;
  final String itemId;
  RewardItemEntity({required this.itemCount, required this.itemId});

  factory RewardItemEntity.fromApi(Map map) {
    return RewardItemEntity(
      itemCount: map['item_count'],
      itemId: map['item_id'],
    );
  }
}
