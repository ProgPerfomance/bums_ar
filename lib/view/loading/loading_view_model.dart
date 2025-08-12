import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repository/user_repository.dart';
import '../../service_locator.dart';

class LoadingViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();

  Future<bool>? _loadFuture;

  Future<bool> ensureUserLoaded() {
    _loadFuture ??= _load();
    return _loadFuture!;
  }

  Future<bool> _load() async {

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final String? userId = await sharedPreferences.getString("userId");

    if(userId == null) {
      return false;
    }

    await _userRepository.getUserById(userId);
    return true;
  }
}
