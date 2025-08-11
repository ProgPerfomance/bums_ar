import 'package:bums_ar/core/colors.dart';
import 'package:bums_ar/domain/entities/shop_item_entity.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view.dart';
import 'package:bums_ar/view/main/shop/buy_item/buy_item_view_model.dart';
import 'package:bums_ar/view/main/shop/sell_alert/sell_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyItemView extends StatelessWidget {
  final ShopItemEntity shopItem;
  const BuyItemView({super.key, required this.shopItem});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BuyItemViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShopTopBar(),
              SizedBox(height: 72),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.8,
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(shopItem.item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                shopItem.item.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "${shopItem.basePrice} руб/шт",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                shopItem.item.description,
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SellAlertButton(text: "Убрать все", onTap: ({int? count}) => vm.removeAll(),),
                  SizedBox(width: 12,),
                  SellAlertButton(text: "-1", onTap: ({int? count}) => vm.removeOne()),
                  SizedBox(width: 12,),
                  Text(vm.buyCount.toString(),style: TextStyle(
                    fontWeight: FontWeight.bold,color: Colors.white
                  ),),
                  SizedBox(width: 12,),
                  SellAlertButton(text: "+1", onTap: ({int? count}) => vm.addOne(),),
                  SizedBox(width: 12,),
                  SellAlertButton(text: "+10", onTap: ({int? count}) => vm.add10()),
                ],
              ),
              SizedBox(height: 24,),
              Center(
                child: GestureDetector(
                  onTap: () {
                    vm.buyItem(shopItem.shopId, shopItem.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 54,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withAlpha(33),
                    ),
                    child: Center(
                      child: Text(
                        "Купить",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 42),
            ],
          ),
        ),
      ),
    );
  }
}
