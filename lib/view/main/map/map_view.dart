import 'dart:async';
import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:bums_ar/view/main/battle/battle_view.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view.dart';
import 'package:bums_ar/view/main/shop/convenience_store/convenience_store_view.dart';
import 'package:bums_ar/view/widgets/main_buttons.dart';
import 'package:bums_ar/view/widgets/offline_point_map_card_widget.dart';
import 'package:bums_ar/view/widgets/overlay/overlay_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bums_ar/view/main/map/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  Timer? _geoTimer;

  @override
  void initState() {
    super.initState();
    _initLocationLoop();
  }

  @override
  void dispose() {
    _geoTimer?.cancel();
    super.dispose();
  }

  Future<void> _initLocationLoop() async {
    // 1) Проверка сервисов и разрешений
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Можно показать диалог или просто выйти
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return;
    }

    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null && mounted) {
        final vm = context.read<MapViewModel>();
        vm.updateUserPosition(LatLng(last.latitude, last.longitude));
      }
    } catch (_) {}

    _geoTimer?.cancel();
    _geoTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best, // можно уменьшить до balanced
          timeLimit: const Duration(seconds: 4),
        );

        if (!mounted) return;
        final vm = context.read<MapViewModel>();
        final latLng = LatLng(pos.latitude, pos.longitude);

        vm.updateUserPosition(latLng);

      } catch (e) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MapViewModel>(context);

    final markers =
        vm.items.map((loc) {
          final coords = loc.position;
          final canPick = vm.canPickup(loc.id);

          return Marker(
            width: 38,
            height: 38,
            point: LatLng(coords.latitude, coords.longitude),
            child: GestureDetector(
              onTap: () async{
                print("pick");
                await vm.pickItem(loc.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: canPick ? Colors.green : Colors.grey,
                    width: 3,
                  ),
                  color: (canPick ? Colors.green : Colors.grey).withAlpha(50),
                ),
                padding: const EdgeInsets.all(4),
                child: Center(child: Image.network(loc.item.imageUrl)),
              ),
            ),
          );
        }).toList();

    final shops =
    vm.shops.map((loc) {
      final coords = loc.position;
      final canPick = vm.canPickup(loc.id);

      return Marker(
        width: 38,
        height: 38,
        point: LatLng(coords.latitude, coords.longitude),
        child: ShopMarker(canPick: false, shop: loc,),
      );
    }).toList();

    final npc =
    vm.npc.map((loc) {
      final coords = loc;
     // final canPick = vm.canPickup(loc.id);

      return Marker(
        width: 38,
        height: 38,
        point: LatLng(coords.position.latitude, coords.position.longitude),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> BattleView()));
          },
            child: Icon(Icons.password)),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onMapReady: () async {
                  _centerOnUser();
                 await vm.getMarkers();
                },
                initialCenter: vm.userPosition,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    ...markers, ...shops, ...npc,
                    Marker(
                      point: vm.userPosition,
                      child: const Icon(Icons.person),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18),
              child: OverlayWidget(stats: vm.user.stats,rub: vm.user.rub,),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: MainButtons(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _centerOnUser() {
    final vm = context.read<MapViewModel>();
    _mapController.move(vm.userPosition, _mapController.camera.zoom);
  }
}

class ShopMarker extends StatelessWidget {
  final ShopEntity shop;
  final bool canPick;
  const ShopMarker({super.key, required this.canPick, required this.shop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(shop.type == "trash_sell") {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => BottleShopView(shop: shop,)));
        }
        else if (shop.type == "base_shop") {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ConvenienceStoreView(shop: shop)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: canPick ? Colors.green : Colors.grey,
            width: 3,
          ),
          color: (canPick ? Colors.green : Colors.grey).withAlpha(50),
        ),
        padding: const EdgeInsets.all(4),
        child: Center(child: Icon(Icons.score)),
      ),
    );
  }
}




