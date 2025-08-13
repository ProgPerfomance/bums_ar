import 'package:bums_ar/core/services/remote_service.dart';
import 'package:bums_ar/domain/entities/user_entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  UserEntity? _activeUser;

  void setActiveUser(UserEntity user) {
    _activeUser = user;
  }

  UserEntity get activeUser => _activeUser!;
  Future<void> getUserById(String userId) async {
    try {
      final response = await RemoteService.getUserById(userId);

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

  Future<List<InventoryItem>> getUserInventory() async {
    final response = await RemoteService.getUserInventory(activeUser.id);

    List data = response.data;

    return data.map((v) => InventoryItem.fromApi(v)).toList();
  }

  Future<bool> loginUser(String email, String password) async {

    final response = await RemoteService.loginUser(email, password);
    if(response.data['e'] != null) {
      return false;
    }
    else {
      _activeUser = UserEntity.fromApi(response.data);
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("userId", response.data['_id']);
    return true;
  }

  Future<void> healUser(int heal) async {
    final response = await RemoteService.healUser(activeUser.id, heal);
    _activeUser = _activeUser?.copyWith(stats: _activeUser?.stats.copyWith(heal: response.data['new_heal'] is int ? response.data['new_heal'].toDouble() :  response.data['new_heal']));
  }

  Future<void> damageUser(int damage) async {
    final response = await RemoteService.damageUser(activeUser.id, damage);
    _activeUser = _activeUser?.copyWith(stats: _activeUser?.stats.copyWith(heal: response.data['new_heal'] is int ? response.data['new_heal'].toDouble() :  response.data['new_heal']));
  }

}

void pickItem(String id) {}
