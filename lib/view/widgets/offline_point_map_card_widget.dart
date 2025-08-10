import 'package:flutter/material.dart';

class OfflinePointMapCardWidget extends StatelessWidget {
  const OfflinePointMapCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Color(0xff0F141A),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Супермаркет 8Х8',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        'Супермаркет 8Х8 — маленький, но всегда шумный магазин у дома. Здесь можно найти всё: от дешёвых консервов до случайных редких товаров, которые привозит местный кладовщик. Атмосфера — смесь приглушённого света.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 42,),
                    Center(
                      child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.yellow
                        ),
                        child: Center(
                          child: Text("Перейти в магазин",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
