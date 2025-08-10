import 'package:flutter/material.dart';
import '../../data/repository/user_repository.dart';
import '../../service_locator.dart';

class LoadingViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();

  Future<bool>? _loadFuture; // кеш единственного запуска

  /// Гарантированно грузит юзера только один раз за сессию
  Future<bool> ensureUserLoaded() {
    _loadFuture ??= _load();
    return _loadFuture!;
  }

  Future<bool> _load() async {
    await _userRepository.getUserById(); // ваша загрузка
    return true;
  }
}
