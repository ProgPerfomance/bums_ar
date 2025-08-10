import 'package:bums_ar/view/main/shop/sell_alert/sell_alert_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors.dart';
import '../../../../domain/entities/shop_entity.dart';
import '../../../../domain/entities/shop_item_entity.dart';

class SellAlert extends StatelessWidget {
  final ShopItemEntity shopItem;
  final ShopEntity shop;
  final int maxCount;
  const SellAlert({
    super.key,
    required this.shopItem,
    required this.shop,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SellAlertWidgetModel>(context);
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.mainBlue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 74,
                  width: 74,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(shopItem.item.imageUrl),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      shopItem.item.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${shopItem.sellPrice} руб/шт',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SellAlertButton(
                  text: "-${vm.sellCount}",
                  onTap: ({int? count}) => vm.removeAll(),
                ),
                SizedBox(width: 12),
                SellAlertButton(
                  text: "-1",
                  onTap: ({int? count}) => vm.removeOne(),
                ),
                SizedBox(width: 12),
                Text(
                  vm.sellCount.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(width: 12),
                SellAlertButton(
                  text: "+1",
                  onTap: ({int? count}) => vm.addOne(maxCount),
                ),
                SizedBox(width: 12),
                SellAlertButton(
                  text: "Все",
                  onTap: ({int? count}) => vm.addAll(maxCount),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  "Сумма: ${vm.totalSum(shopItem.sellPrice)} руб",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Container(
                  height: 52,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withAlpha(30),
                  ),
                  child: Center(
                    child: Text(
                      "Продать",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SellAlertButton extends StatelessWidget {
  final String text;
  final void Function({int? count}) onTap;

  const SellAlertButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(), // тут вызов, а не ссылка
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withAlpha(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
