import 'package:bums_ar/core/services/remote_service.dart';
import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:latlong2/latlong.dart';

class UserRepository {
  UserEntity? _activeUser;

  void setActiveUser(UserEntity user) {
    _activeUser = user;
  }

  UserEntity get activeUser => _activeUser!;
  Future<void> getUserById(String userId) async {
    try {
      final response = await RemoteService.getUserById(
       userId,
      );

      _activeUser = UserEntity.fromApi(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserPosition(double lat, double long) async {
    final response = await RemoteService.updateUserPosition(
      activeUser.id,
      lat,
      long,
    );
  }

  Future<List<InventoryItem>> getUserInventory () async {

    final response = await RemoteService.getUserInventory(activeUser.id);

    List data = response.data;

    return data.map((v)=> InventoryItem.fromApi(v)).toList();

  }

}

void pickItem(String id) {}
