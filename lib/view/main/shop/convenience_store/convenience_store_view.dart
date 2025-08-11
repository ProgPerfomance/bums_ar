import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:flutter/material.dart';

class ConvenienceStoreView extends StatelessWidget {
  final ShopEntity shop;
  const ConvenienceStoreView({super.key, required this.shop,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(shop.backgroundImageUrl ?? ""))
            ),
          ),
        ],
      ),
    );
  }
}
