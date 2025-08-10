// где-то при старте приложения
import 'package:bums_ar/data/repository/items_repository.dart';
import 'package:bums_ar/data/repository/shop_repository.dart';
import 'package:bums_ar/data/repository/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'core/services/location_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(UserRepository());
  getIt.registerSingleton(ItemsRepository());
  getIt.registerSingleton(ShopRepository());
}
