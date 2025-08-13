import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors.dart';
import '../battle_view_model.dart';

class StartBattleSheet extends StatelessWidget {
  const StartBattleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BattleViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    final rewards = <_Reward>[
      _Reward(
        title: 'Стеклотара',
        imageUrl: 'https://pub-905d0147f1b544f293d2033902230995.r2.dev/image%2033.png',
        count: 3,
        rarityColor: Colors.green.shade700,
      ),
      _Reward(
        title: 'Алюм. банка',
        imageUrl: 'https://pub-905d0147f1b544f293d2033902230995.r2.dev/image%2033.png',
        count: 5,
        rarityColor: Colors.blueGrey.shade600,
      ),
      _Reward(
        title: 'Ржавая цепь',
        imageUrl: 'https://pub-905d0147f1b544f293d2033902230995.r2.dev/image%2033.png',
        count: 1,
        rarityColor: Colors.orange.shade800,
      ),
      _Reward(
        title: 'Ржавая цепь',
        imageUrl: 'https://pub-905d0147f1b544f293d2033902230995.r2.dev/image%2033.png',
        count: 1,
        rarityColor: Colors.orange.shade800,
      ),
      _Reward(
        title: 'Ржавая цепь',
        imageUrl: 'https://pub-905d0147f1b544f293d2033902230995.r2.dev/image%2033.png',
        count: 1,
        rarityColor: Colors.orange.shade800,
      ),
    ];

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
      child: Center(
        child: Container(
          height: 420,
          width: width - 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF2E2E2E),
            border: Border.all(color: Colors.brown.shade700, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Вы хотите начать бой?",
                  style: TextStyle(
                    color: Colors.orange.shade200,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 4,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ==== Награда за бой ====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок секции
                      Row(
                        children: [
                          Icon(Icons.card_giftcard, color: Colors.amber.shade200, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Награда за бой',
                            style: TextStyle(
                              color: Colors.amber.shade200,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Сетка/ряд предметов
                      SizedBox(
                        height: 92,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: rewards.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final r = rewards[index];
                            return _RewardTile(reward: r);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Row(
                  children: [
                    // Скрыться
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red.shade900.withOpacity(0.9),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            "Скрыться",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Начать
                    GestureDetector(
                      onTap: () {
                        vm.startBattleAi();
                        vm.hideStartBattleWindow();
                      },
                      child: Container(
                        height: 50,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green.shade800.withOpacity(0.9),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            "Начать",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Reward {
  final String title;
  final String imageUrl;
  final int count;
  final Color rarityColor;

  _Reward({
    required this.title,
    required this.imageUrl,
    required this.count,
    required this.rarityColor,
  });
}

class _RewardTile extends StatelessWidget {
  final _Reward reward;
  const _RewardTile({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2B2B2B),
            const Color(0xFF2B2B2B).withOpacity(0.9),
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Рамка редкости
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: reward.rarityColor.withOpacity(0.7), width: 2),
              ),
            ),
          ),

          // Превью предмета
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(reward.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  reward.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Бейдж количества
          Positioned(
            right: -4,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                '×${reward.count}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
