import 'package:bums_ar/core/images.dart';
import 'package:bums_ar/view/main/inventory/inventory_view.dart';
import 'package:flutter/material.dart';

class MainButtons extends StatelessWidget {
  const MainButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> InventoryView(
              menuBuilder: (item, index) => [
                InventoryMenuAction(
                  text: 'Использовать',
                  icon: Icons.play_arrow,
                  enabled: true,
                  onTap: () {
                    // логика использования предмета
                  },
                ),
                InventoryMenuAction(
                  text: 'Продать',
                  icon: Icons.attach_money,
                  enabled: true,
                  onTap: () {
                    // логика продажи
                  },
                ),
                InventoryMenuAction(
                  text: 'Выбросить',
                  icon: Icons.delete_outline,
                  enabled: item.item.rarity != 'legendary', // пример условия
                  onTap: () {
                    // логика удаления
                  },
                ),
              ],
            )
            ));
          },
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurpleAccent,
            ),
            child: Center(child: Image.asset(AppImages.backpack),),
          ),
        ),
        SizedBox(height: 12,),
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurpleAccent,
          ),
          child: Center(child: Image.asset(AppImages.phone),),
        )
      ],
    );
  }
}
