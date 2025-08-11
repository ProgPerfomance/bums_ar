import 'dart:ui';
import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view.dart'; // для ShopTopBar
import 'package:bums_ar/view/main/shop/convenience_store/convenience_store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConvenienceStoreView extends StatefulWidget {
  final ShopEntity shop;
  const ConvenienceStoreView({super.key, required this.shop});

  @override
  State<ConvenienceStoreView> createState() => _ConvenienceStoreViewState();
}

class _ConvenienceStoreViewState extends State<ConvenienceStoreView> {
  final Color primary = const Color(0xFF3B82F6); // blue-500
  final Color primaryDark = const Color(0xFF1E40AF); // blue-800
  final Color surface = Colors.white.withOpacity(0.08);

  @override
  void initState() {
    super.initState();
    Provider.of<ConvenienceStoreViewModel>(context, listen: false)
        .initShopData(widget.shop.id);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConvenienceStoreViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // BG image
          Positioned.fill(
            child: widget.shop.backgroundImageUrl != null &&
                widget.shop.backgroundImageUrl!.trim().isNotEmpty
                ? Image.network(
              widget.shop.backgroundImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
            )
                : const ColoredBox(color: Colors.black),
          ),
          // Blue gradient + vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryDark.withOpacity(0.85), Colors.black.withOpacity(0.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Grainy overlay (subtle)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.05)),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const ShopTopBar(),
                  const SizedBox(height: 24),
                  // Header chip
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _GlassChip(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_grocery_store, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'У дома',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: vm.isLoading
                        ? _SkeletonGrid()
                        : GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 3.9,
                      ),
                      itemCount: vm.items.length,
                      itemBuilder: (context, index) {
                        final item = vm.items[index];
                        return _GlassCard(
                          primary: primary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      AnimatedOpacity(
                                        opacity: 1,
                                        duration: const Duration(milliseconds: 300),
                                        child: Image.network(
                                          item.item.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Center(
                                            child: Icon(Icons.image_not_supported, color: Colors.white54),
                                          ),
                                          loadingBuilder: (c, w, progress) {
                                            if (progress == null) return w;
                                            return const _ImageSkeleton();
                                          },
                                        ),
                                      ),
                                      // Price pill
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: _PricePill(
                                          text: '${item.basePrice} ₽',
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Name
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  item.item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // CTA
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      // TODO: открыть карточку товара / добавление в корзину
                                    },
                                    child: const Text(
                                      'Купить',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color primary;
  const _GlassCard({required this.child, required this.primary});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.18),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  final String text;
  final Color color;
  const _PricePill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withOpacity(0.95),
        shape: StadiumBorder(side: BorderSide(color: Colors.white.withOpacity(0.35))),
        shadows: [BoxShadow(color: color.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final Widget child;
  const _GlassChip({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 3.9,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          padding: const EdgeInsets.all(10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _ShimmerBox()),
              SizedBox(height: 10),
              _ShimmerBox(height: 14, radius: 6),
              SizedBox(height: 8),
              _ShimmerBox(height: 36, radius: 12),
              SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerBox();
  }
}

class _ShimmerBox extends StatefulWidget {
  final double? height;
  final double? radius;
  const _ShimmerBox({this.height, this.radius});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  late final Animation<double> _a = Tween(begin: -1.0, end: 2.0).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 12),
            gradient: LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.14),
                Colors.white.withOpacity(0.06),
              ],
              stops: [(_a.value - 0.3).clamp(0.0, 1.0), _a.value.clamp(0.0, 1.0), (_a.value + 0.3).clamp(0.0, 1.0)],
            ),
          ),
        );
      },
    );
  }
}
