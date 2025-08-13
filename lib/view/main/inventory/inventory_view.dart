import 'package:bums_ar/view/main/inventory/inventory_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/user_entity.dart';



class InventoryView extends StatefulWidget {
  /// Билдер действий меню, передаётся извне
  final InventoryMenuBuilder<InventoryItem>? menuBuilder;

  const InventoryView({super.key, this.menuBuilder});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<InventoryViewmodel>(context, listen: false);
    vm.getItems();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InventoryViewmodel>(context);

    return Scaffold(
      backgroundColor: const Color(0xff0F141A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F141A),
        elevation: 0,
        title: const Text('Инвентарь'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 54,
            itemBuilder: (context, index) {
              if (vm.items.length > index) {
                final invItem = vm.items[index];
                final cellKey = GlobalKey();

                return GestureDetector(
                  key: cellKey,
                  onTapDown: (details) async {
                    // Если действий не передали — ничего не показываем
                    if (widget.menuBuilder == null) return;

                    final actions = widget.menuBuilder!.call(invItem, index);
                    if (actions.isEmpty) return;

                    // Позиционирование меню под карточкой
                    final renderBox = cellKey.currentContext?.findRenderObject() as RenderBox?;
                    if (renderBox == null) return;

                    final offset = renderBox.localToGlobal(Offset.zero);
                    final size = renderBox.size;

                    final selected = await showMenu<int>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy + size.height, // под карточкой
                        offset.dx + size.width,
                        offset.dy,
                      ),
                      items: List.generate(actions.length, (i) {
                        final a = actions[i];
                        return PopupMenuItem<int>(
                          value: i,
                          enabled: a.enabled,
                          child: Row(
                            children: [
                              Icon(a.icon, size: 18),
                              const SizedBox(width: 10),
                              Expanded(child: Text(a.text)),
                            ],
                          ),
                        );
                      }),
                    );

                    if (selected != null) {
                      final chosen = actions[selected];
                      // Закрыть меню уже произошло — вызываем действие
                      chosen.onTap();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: getBackgroundColor(invItem.item.rarity),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withAlpha(30), width: 3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        invItem.item.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // Пустая ячейка
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(30), width: 3),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Цвет подложки по редкости
Color getBackgroundColor(String rarity) {
  switch (rarity) {
    case "common":
      return Colors.grey.withAlpha(60);
    case "uncommon":
      return const Color(0xFF7BB661).withAlpha(60); // зелень
    case "rare":
      return Colors.yellow.withAlpha(73);
    case "epic":
      return const Color(0xFF9C27B0).withAlpha(60); // фиолетовый
    case "legendary":
      return const Color(0xFFFF9800).withAlpha(60); // оранжевый
    default:
      return Colors.grey.withAlpha(60);
  }
}


class InventoryMenuAction {
  final String text;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const InventoryMenuAction({
    required this.text,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });
}

/// Билдер действий извне для конкретного предмета/ячейки
typedef InventoryMenuBuilder<T> = List<InventoryMenuAction> Function(T item, int index);

