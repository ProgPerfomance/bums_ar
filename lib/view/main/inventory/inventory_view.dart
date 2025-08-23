import 'package:bums_ar/view/main/inventory/inventory_viewmodel.dart';
import 'package:bums_ar/view/main/inventory/widgets/inventory_person.dart';
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
        centerTitle: false,
        title: const Text(
          'Инвентарь',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => Provider.of<InventoryViewmodel>(context, listen: false).getItems(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
               SizedBox(
                 height:400,
               child:  EquipmentView(equipped: {}),
               ),
                Expanded(child:  LayoutBuilder(
                  builder: (context, constraints) {
                    // Адаптивное количество колонок
                    final tileMinWidth = 90.0; // целимся в ~90–110px
                    final crossAxisCount = (constraints.maxWidth / tileMinWidth).clamp(3, 8).floor();

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: 54, // фиксированная сетка как и было
                      itemBuilder: (context, index) {
                        if (vm.items.length > index) {
                          final invItem = vm.items[index];
                          return _InventoryTile(
                            invItem: invItem,
                            onShowMenu: widget.menuBuilder == null
                                ? null
                                : (globalRect) async {
                              final actions = widget.menuBuilder!.call(invItem, index);
                              if (actions.isEmpty) return;

                              final selected = await showMenu<int>(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  globalRect.left,
                                  globalRect.bottom,
                                  globalRect.right,
                                  globalRect.top,
                                ),
                                items: List.generate(actions.length, (i) {
                                  final a = actions[i];
                                  return PopupMenuItem<int>(
                                    value: i,
                                    enabled: a.enabled,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                                chosen.onTap();
                              }
                            },
                          );
                        } else {
                          // Пустая ячейка
                          return _EmptySlot();
                        }
                      },
                    );
                  },
                ),),
              ],
            )
          ),
        ),
      ),
    );
  }
}

/// Плитка предмета инвентаря с аккуратным фоном по редкости, мягкой рамкой и плавной подгрузкой изображения
class _InventoryTile extends StatefulWidget {
  final dynamic invItem; // ожидаем, что у invItem есть .item с полями imageUrl, rarity
  final Future<void> Function(Rect globalRect)? onShowMenu;

  const _InventoryTile({
    required this.invItem,
    this.onShowMenu,
  });

  @override
  State<_InventoryTile> createState() => _InventoryTileState();
}

class _InventoryTileState extends State<_InventoryTile> {
  final GlobalKey _cellKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final item = widget.invItem.item;
    final rarity = (item.rarity as String?) ?? 'common';
    final bg = _rarityBackground(rarity);
    final border = _rarityBorder(rarity);
    final glow = _rarityGlow(rarity);

    return GestureDetector(
      key: _cellKey,
      onTapDown: (details) async {
        if (widget.onShowMenu == null) return;
        final box = _cellKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null) return;
        final offset = box.localToGlobal(Offset.zero);
        final rect = offset & box.size;
        await widget.onShowMenu!(rect);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 2),
          boxShadow: [
            BoxShadow(
              color: glow,
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              // лёгкая диагональная фактура без изображений
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x11000000), Color(0x00000000)],
              ),
            ),
            child: _FadeInNetworkImage(
              url: item.imageUrl as String,
            ),
          ),
        ),
      ),
    );
  }
}

/// Пустая ячейка с опрятной рамкой и «плюсом»
class _EmptySlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x09000000),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.18), width: 2),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.white30, size: 22),
      ),
    );
  }
}

/// Плавная подгрузка картинки без сторонних пакетов
class _FadeInNetworkImage extends StatelessWidget {
  final String url;
  const _FadeInNetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 200),
            child: child,
          );
        }
        return const _ImageSkeleton();
      },
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white38),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const _ImageSkeleton();
      },
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

/// Цвета/эффекты по редкости
Color _rarityBgColor(String rarity) {
  switch (rarity) {
    case 'uncommon':
      return const Color(0xFF2E442F);
    case 'rare':
      return const Color(0xFF4A3F22);
    case 'epic':
      return const Color(0xFF362B3D);
    case 'legendary':
      return const Color(0xFF4A3316);
    case 'common':
    default:
      return const Color(0xFF1A1F26);
  }
}

Color _rarityBorder(String rarity) {
  switch (rarity) {
    case 'uncommon':
      return const Color(0xFF7BB661);
    case 'rare':
      return const Color(0xFFE6C15A);
    case 'epic':
      return const Color(0xFFB388FF);
    case 'legendary':
      return const Color(0xFFFFB74D);
    case 'common':
    default:
      return Colors.white24;
  }
}

Color _rarityGlow(String rarity) {
  switch (rarity) {
    case 'uncommon':
      return const Color(0x557BB661);
    case 'rare':
      return const Color(0x55E6C15A);
    case 'epic':
      return const Color(0x55B388FF);
    case 'legendary':
      return const Color(0x55FFB74D);
    case 'common':
    default:
      return Colors.transparent;
  }
}

Color _rarityBackground(String rarity) {
  // Небольшая прозрачность, чтобы фон сливался с общим тоном
  return _rarityBgColor(rarity).withOpacity(0.6);
}

/// Цвет подложки по редкости (оставлено для совместимости с твоим кодом, если где-то вызвано)
Color getBackgroundColor(String rarity) => _rarityBackground(rarity);

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
