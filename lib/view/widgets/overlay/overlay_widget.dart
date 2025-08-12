import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:bums_ar/view/main/profile/user_profile/user_profile_view.dart';
import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  final UserStats stats;
  final int rub;
  const OverlayWidget({super.key, required this.stats, required this.rub});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfileView()));
          },
            child: CircleAvatar(backgroundColor: Colors.grey, radius: 32)),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatContainer(count: stats.heal, color: Colors.red, max: 100),
            SizedBox(height: 8),
            StatContainer(count: stats.water, color: Colors.blue, max: 100),
            SizedBox(height: 8),
            StatContainer(count: stats.food, color: Colors.orange, max: 100),
            SizedBox(height: 8,),
            Text('$rub рублей')
          ],
        ),
      ],
    );
  }
}

class StatContainer extends StatelessWidget {
  final Color color;
  final double max;
  final double count;
  const StatContainer({
    super.key,
    required this.count,
    required this.color,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width / 2; // ширина всего контейнера
    final percent = (count / max).clamp(0.0, 1.0); // от 0 до 1

    return Container(
      width: totalWidth,
      height: 8,
      decoration: BoxDecoration(
        color: color.withAlpha(83),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: totalWidth * percent,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

