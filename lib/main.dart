import 'package:bums_ar/service_locator.dart';
import 'package:bums_ar/view/loading/loading_view.dart';
import 'package:bums_ar/view/loading/loading_view_model.dart';
import 'package:bums_ar/view/main/inventory/inventory_viewmodel.dart';
import 'package:bums_ar/view/main/map/map_view.dart';
import 'package:bums_ar/view/main/map/map_view_model.dart';
import 'package:bums_ar/view/main/profile/user_profile/user_profile_view_model.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view_model.dart';
import 'package:bums_ar/view/main/shop/buy_item/buy_item_view_model.dart';
import 'package:bums_ar/view/main/shop/convenience_store/convenience_store_view.dart';
import 'package:bums_ar/view/main/shop/convenience_store/convenience_store_view_model.dart';
import 'package:bums_ar/view/main/shop/sell_alert/sell_alert_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> MapViewModel()),
        ChangeNotifierProvider(create: (context)=> LoadingViewModel()),
        ChangeNotifierProvider(create: (context)=> InventoryViewmodel()),
        ChangeNotifierProvider(create: (context)=> BottleShopViewModel()),
        ChangeNotifierProvider(create: (context)=> SellAlertWidgetModel()),
        ChangeNotifierProvider(create: (context)=> ConvenienceStoreViewModel()),
        ChangeNotifierProvider(create: (context)=> BuyItemViewModel()),
        ChangeNotifierProvider(create: (context)=> UserProfileViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingView(),
      ),
    );
  }
}


final List<Map<String, dynamic>> locations = [
  {
    "_id": "689299c451bb68738ef5d779",
    "coordinates": [30.333837, 59.938732]
  },
  {
    "_id": "68956b733e5a485beb000000",
    "coordinates": [30.329486852972444, 59.93994050550482]
  },
  {
    "_id": "68956b733e5a495beb000000",
    "coordinates": [30.334520826778668, 59.93811079526031]
  },
  {
    "_id": "68956b733e5a4a5beb000000",
    "coordinates": [30.33775516048454, 59.937626963927976]
  },
  {
    "_id": "68956b733e5a4b5beb000000",
    "coordinates": [30.33259267873489, 59.938101377051325]
  },
  {
    "_id": "68956b733e5a4c5beb000000",
    "coordinates": [30.332121544937646, 59.93911873063819]
  },
  {
    "_id": "68956b733e5a4d5beb000000",
    "coordinates": [30.331262936203586, 59.9374261258885]
  },
  {
    "_id": "68956b733e5a4e5beb000000",
    "coordinates": [30.337309452020275, 59.93893122143012]
  },
  {
    "_id": "68956b733e5a4f5beb000000",
    "coordinates": [30.3376697474332, 59.93932577306763]
  },
  {
    "_id": "68956b733e5a505beb000000",
    "coordinates": [30.33077576520199, 59.93814911589667]
  },
  {
    "_id": "68956b733e5a515beb000000",
    "coordinates": [30.33473565540127, 59.93827285238352]
  },
  {
    "_id": "68956b733e5a525beb000000",
    "coordinates": [30.331492202857802, 59.93807059778121]
  },
  {
    "_id": "68956b733e5a535beb000000",
    "coordinates": [30.33538693645797, 59.93643391124731]
  },
  {
    "_id": "68956b733e5a545beb000000",
    "coordinates": [30.33239200937534, 59.93970518161577]
  },
  {
    "_id": "68956b733e5a555beb000000",
    "coordinates": [30.333919229793928, 59.94067333591711]
  },
  {
    "_id": "68956b733e5a565beb000000",
    "coordinates": [30.33538472538093, 59.93671077390221]
  },
  {
    "_id": "68956b733e5a575beb000000",
    "coordinates": [30.334337725893754, 59.94112043161104]
  },
  {
    "_id": "68956b733e5a585beb000000",
    "coordinates": [30.33062127588314, 59.93969550838145]
  },
  {
    "_id": "68956b733e5a595beb000000",
    "coordinates": [30.333714717025117, 59.937538737299725]
  },
  {
    "_id": "68956b733e5a5a5beb000000",
    "coordinates": [30.335086421134633, 59.93976149959565]
  },
  {
    "_id": "68956b733e5a5b5beb000000",
    "coordinates": [30.33692073367555, 59.93754271774242]
  },
  {
    "_id": "68956b733e5a5c5beb000000",
    "coordinates": [30.331006896441398, 59.9387175400522]
  },
  {
    "_id": "68956b733e5a5d5beb000000",
    "coordinates": [30.337641101407502, 59.93747539617248]
  },
  {
    "_id": "68956b733e5a5e5beb000000",
    "coordinates": [30.3315343021289, 59.93813870721561]
  },
  {
    "_id": "68956b733e5a5f5beb000000",
    "coordinates": [30.336734010750348, 59.93973565247997]
  },
  {
    "_id": "68956b733e5a605beb000000",
    "coordinates": [30.334391105475056, 59.94074561920148]
  },
  {
    "_id": "68956b733e5a615beb000000",
    "coordinates": [30.33291572761326, 59.94059147320691]
  },
  {
    "_id": "68956b733e5a625beb000000",
    "coordinates": [30.334920358365558, 59.93949718458673]
  },
  {
    "_id": "68956b733e5a635beb000000",
    "coordinates": [30.33760304355115, 59.93912136257306]
  },
  {
    "_id": "68956b733e5a645beb000000",
    "coordinates": [30.338900927858127, 59.93920147191534]
  },
  {
    "_id": "68956b733e5a655beb000000",
    "coordinates": [30.33636474434577, 59.94030420222757]
  },
  {
    "_id": "68956b733e5a665beb000000",
    "coordinates": [30.339027897298898, 59.93830402931465]
  },
  {
    "_id": "68956b733e5a675beb000000",
    "coordinates": [30.337693160889962, 59.93801314482858]
  },
  {
    "_id": "68956b733e5a685beb000000",
    "coordinates": [30.330460310633022, 59.94077318186901]
  },
  {
    "_id": "68956b733e5a695beb000000",
    "coordinates": [30.33109907436226, 59.94076542443765]
  },
  {
    "_id": "68956b733e5a6a5beb000000",
    "coordinates": [30.337796862060934, 59.93994051596082]
  },
  {
    "_id": "68956b733e5a6b5beb000000",
    "coordinates": [30.33444109734709, 59.94008064135876]
  },
  {
    "_id": "68956b733e5a6c5beb000000",
    "coordinates": [30.338310320158435, 59.9396409836933]
  },
  {
    "_id": "68956b733e5a6d5beb000000",
    "coordinates": [30.334977632257615, 59.93647107541841]
  },
  {
    "_id": "68956b733e5a6e5beb000000",
    "coordinates": [30.335344090944254, 59.938683309803196]
  },
];
