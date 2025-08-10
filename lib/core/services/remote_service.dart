import 'package:dio/dio.dart';

class RemoteService {
  static Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:5010"));

  static Future<Response> getMapItems(double lat, double long) async {
    final response = await dio.post(
      "/map/items",
      data: {"lat": lat, "long": long},
    );
    return response;
  }

  static Future<Response> getMapShops(double lat, double long) async {
    final response = await dio.post(
      "/map/shops",
      data: {"lat": lat, "long": long},
    );
    return response;
  }

  static Future<Response> getUserById(String userId) async {
    try {
      final response = await dio.get("/users/$userId");
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Response> pickItem(String itemId, String userId) async {
    final response = await dio.post(
      "/users/item/pick",
      data: {
        "user": {"_id": userId},
        "item": {"_id": itemId},
      },
    );
    return response;
  }

  static Future<Response> updateUserPosition(
    String userId,
    double lat,
    double long,
  ) async {
    final response = await dio.put(
      "/users/position",
      data: {"user_id": userId, "lat": lat, "long": long},
    );

    return response;
  }

  static Future<Response> getUserInventory(String userId) async {
    final response = await dio.get("/users/inventory/$userId");

    return response;
  }

  static Future<Response> getShopItems(String shopId) async {
    final response = await dio.get("/shops/items/$shopId");
    return response;
  }

  static Future<Response> sellItemInShop(
    String itemId,
    int itemCount,
    String shopId,
  ) async {
    final response = await dio.get(
      "/shops/items/sell",
      data: {"item_id": itemId, "item_count": itemCount, "shop_id": shopId},
    );
    return response;
  }
}
