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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> InventoryView()));
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
