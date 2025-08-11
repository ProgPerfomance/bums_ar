import 'package:bums_ar/view/main/inventory/inventory_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InventoryViewmodel>(context);
    return Scaffold(
      backgroundColor: Color(0xff0F141A),
      appBar: AppBar(
        backgroundColor: Color(0xff0F141A),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,crossAxisSpacing: 10,mainAxisSpacing: 10), itemBuilder: (context, index) {

         if(vm.items.length > index) {
           final item = vm.items[index];
           return Container(
             decoration: BoxDecoration(
                 color: getBackgroundColor(item.item.rarity),
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.white.withAlpha(30), width: 3)
             ),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Image.network(item.item.imageUrl),
             ),
           );
         }
         else {
           return Container(
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.white.withAlpha(30), width: 3)
             ),
           );
         }
        }, itemCount: 54,),
      )),
    );
  }
  @override
  void initState() {
    final vm = Provider.of<InventoryViewmodel>(context, listen: false);
    vm.getItems();
    super.initState();
  }

}

Color getBackgroundColor (String rarity) {
  switch (rarity) {
    case "rare":
      return Colors.yellow.withAlpha(73);
    default:
      return Colors.grey.withAlpha(73);
  }
}