import 'package:flutter/material.dart';

import '../../../../data/repository/user_repository.dart';
import '../../../../service_locator.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();
  Future<bool> login (String email, String password) async {
    return _userRepository.loginUser(email, password);
  }

}