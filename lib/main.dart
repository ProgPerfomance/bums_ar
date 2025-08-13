import 'package:bums_ar/view/main/battle/battle_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bums_ar/service_locator.dart';
import 'package:bums_ar/view/loading/loading_view.dart';
import 'package:bums_ar/view/loading/loading_view_model.dart';
import 'package:bums_ar/view/main/auth/login/login_view_model.dart';
import 'package:bums_ar/view/main/inventory/inventory_viewmodel.dart';
import 'package:bums_ar/view/main/map/map_view_model.dart';
import 'package:bums_ar/view/main/profile/user_profile/user_profile_view_model.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view_model.dart';
import 'package:bums_ar/view/main/shop/buy_item/buy_item_view_model.dart';
import 'package:bums_ar/view/main/shop/convenience_store/convenience_store_view_model.dart';
import 'package:bums_ar/view/main/shop/sell_alert/sell_alert_widget_model.dart';

import 'core/services/app_money_notificaions.dart';



final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() {
  setupLocator();
  // инициализация сервиса оверлея
  DeltaOverlay.instance.init(navKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => LoadingViewModel()),
        ChangeNotifierProvider(create: (_) => InventoryViewmodel()),
        ChangeNotifierProvider(create: (_) => BottleShopViewModel()),
        ChangeNotifierProvider(create: (_) => SellAlertWidgetModel()),
        ChangeNotifierProvider(create: (_) => ConvenienceStoreViewModel()),
        ChangeNotifierProvider(create: (_) => BuyItemViewModel()),
        ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => BattleViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        home: const Scaffold(body: LoadingView()),
      ),
    );
  }
}
