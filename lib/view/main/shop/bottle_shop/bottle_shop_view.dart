import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:bums_ar/domain/entities/shop_item_entity.dart';
import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottleShopView extends StatefulWidget {
  final ShopEntity shop;
  const BottleShopView({super.key, required this.shop});

  @override
  State<BottleShopView> createState() => _BottleShopViewState();
}

class _BottleShopViewState extends State<BottleShopView> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<BottleShopViewModel>(context, listen: false);
    vm.initShopData(widget.shop.id);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BottleShopViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: (){
              vm.closeSellSheet();
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.shop.backgroundImageUrl ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ShopTopBar(user: vm.user),
                      const SizedBox(height: 72),
                      Expanded(child: ListView.separated(itemBuilder: (context,index) {
                        return RecyclingItemCard(shopItem: vm.items[index],userItems: vm.userItems,shop: widget.shop,);
                      }, separatorBuilder: (context,index) {
                        return SizedBox(height: 12,);
                      }, itemCount: vm.items.length)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(alignment: Alignment.center,child: vm.sellSheet),
        ],
      ),
    );
  }
}

class ShopExitButton extends StatelessWidget {
  const ShopExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withAlpha(30),
        ),
        child: const Center(
          child: Icon(CupertinoIcons.back, color: Colors.white),
        ),
      ),
    );
  }
}



class RecyclingItemCard extends StatelessWidget {
  final ShopEntity shop;
  final ShopItemEntity shopItem;
  final List<InventoryItem> userItems;
  const RecyclingItemCard({
    super.key,
    required this.shopItem,
    required this.userItems,
    required this.shop,
  });



  @override
  Widget build(BuildContext context) {

    final int qty = userItems.where((v)=> v.item.id == shopItem.item.id).toList().length;
    final disabled = qty == 0;
    // Палитра под тёмно-синий
    final cardBg = disabled ? const Color(0xFF0F141A) : const Color(0xFF121922);
    final border = disabled ? const Color(0xFF1C2632) : const Color(0xFF243041);
    final titleCol = disabled ? Colors.white38 : Colors.white;
    final subCol = disabled ? Colors.white30 : Colors.white70;
    final btnBg = disabled ? const Color(0xFF17202A) : const Color(0xFF1B2633); // менее яркая
    final btnBr = disabled ? const Color(0xFF243041) : const Color(0xFF2A3A4D);
    final btnTx = disabled ? Colors.white38 : Colors.white70;
    final vm = Provider.of<BottleShopViewModel>(context);
    return Container(
      height: 128, // больше карточка
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Изображение с бейджем количества в углу
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: Stack(
              children: [
                Container(
                  width: 116,
                  height: double.infinity,
                  color: const Color(0xFF0B1117),
                  child: Image.network(
                    shopItem.item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => const Center(
                      child: Icon(Icons.image_not_supported_outlined, color: Colors.white24),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _QtyChip(qty: qty, disabled: disabled),
                ),
              ],
            ),
          ),

          // Контент
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Больше места под название: 2 строки, вся ширина
                  Text(
                    shopItem.item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleCol,
                      fontSize: 16.5,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₽ ${shopItem.sellPrice} / шт.',
                          style: TextStyle(
                            color: subCol,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        child: TextButton(
                          onPressed: disabled ? null : () {
                            vm.setSellSheet(shopItem, shop, qty);
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            backgroundColor: WidgetStateProperty.all(btnBg),
                            overlayColor: WidgetStateProperty.all(Colors.white10),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: btnBr),
                              ),
                            ),
                          ),
                          child: Text(
                            'Продать',
                            style: TextStyle(
                              color: btnTx,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyChip extends StatelessWidget {
  const _QtyChip({required this.qty, required this.disabled});
  final int qty;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final bg = disabled ? const Color(0xFF1A2430) : const Color(0xFF1E2A39);
    final br = disabled ? const Color(0xFF253245) : const Color(0xFF2F3E52);
    final tx = disabled ? Colors.white30 : Colors.white70;

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: br),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '× $qty',
          style: TextStyle(
            color: tx,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}


// Expanded(
//   child: vm.isLoading
//       ? const Center(
//     child: CircularProgressIndicator(
//       valueColor: AlwaysStoppedAnimation<Color>(
//         Colors.white,
//       ),
//     ),
//   )
//       : GridView.builder(
//     gridDelegate:
//     const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2,
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//     ),
//     itemCount: vm.items.length,
//     itemBuilder: (context, index) {
//       return Container(
//         height: 100,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white.withAlpha(30),
//         ),
//         child: Center(
//           child: Text(
//             vm.items[index].item.name ?? '',
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     },
//   ),
// ),


class ShopTopBar extends StatelessWidget {
  final UserEntity user;
  const ShopTopBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShopExitButton(),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:  [
            Text(
              "${user.rub}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              "Рублей",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        const CircleAvatar(radius: 30),
      ],
    );
  }
}
