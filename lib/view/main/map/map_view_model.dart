import 'package:bums_ar/data/repository/items_repository.dart';
import 'package:bums_ar/data/repository/npc_repository.dart';
import 'package:bums_ar/data/repository/shop_repository.dart';
import 'package:bums_ar/domain/entities/npc_entity.dart';
import 'package:bums_ar/domain/entities/shop_entity.dart';
import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:bums_ar/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/repository/user_repository.dart';
import '../../../domain/entities/map_item_entity.dart';

class MapViewModel extends ChangeNotifier {
  final List<Marker> _markers = [];
  List<Marker> get markers => _markers;

  final List<Polygon> _grid = [];
  List<Polygon> get grid => _grid;

  final UserRepository _userRepository = getIt.get<UserRepository>();
  final ItemsRepository _itemsRepository = getIt.get<ItemsRepository>();
  final ShopRepository _shopRepository = getIt.get<ShopRepository>();
  final NpcRepository _npcRepository = getIt.get<NpcRepository>();

  final Distance _geo = const Distance();
  List<MapItemEntity> items = [];
  List<ShopEntity> shops = [];
  List<NpcEntity> npc = [];

  final Map<String, bool> _canPickup = {};
  bool canPickup(String itemId) => _canPickup[itemId] ?? false;

  LatLng get userPosition => _userRepository.activeUser.position;
  UserEntity get user => _userRepository.activeUser;

  /// Получить предметы и пересчитать близость
  Future<void> getMarkers() async {
    final double lat = _userRepository.activeUser.position.latitude;
    final double long = _userRepository.activeUser.position.longitude;
    shops = await _shopRepository.getOfflineShops(lat, long);
    items = await _itemsRepository.getMapItems(lat, long);
    npc = await _npcRepository.getMapNpc(
      _userRepository.activeUser.id,
      lat,
      long,
    );
    _recalcProximity();
  }

  /// Если позиция игрока изменилась — обновляем и пересчитываем близость
  Future<void> updateUserPosition(LatLng pos) async {
    await _userRepository.updateUserPosition(pos.latitude, pos.longitude);
    // _userRepository.setActiveUser(
    //   _userRepository.activeUser.copyWith(position: pos),
    // );
    _recalcProximity();
  }

  /// Внутренний пересчёт дистанций и нотификация подписчиков
  void _recalcProximity({double radiusMeters = 70}) {
    final pos = userPosition;
    _canPickup.clear();

    for (final it in items) {
      final dMeters = _geo.as(
        LengthUnit.Meter,
        pos,
        LatLng(it.position.latitude, it.position.longitude),
      );
      _canPickup[it.id] = dMeters <= radiusMeters;
    }
    notifyListeners();
  }

  /// Если хочешь вручную выставить маркеры
  void setMarkers(List<Marker> newMarkers) {
    _markers
      ..clear()
      ..addAll(newMarkers);
    notifyListeners();
  }

  Future<void> pickItem(String mapItemId) async {
    await _itemsRepository.pickItem(mapItemId, _userRepository.activeUser.id);
    await getMarkers();
  }
}
