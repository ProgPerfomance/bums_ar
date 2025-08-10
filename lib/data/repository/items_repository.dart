
import 'package:bums_ar/core/services/remote_service.dart';
import 'package:bums_ar/domain/entities/map_item_entity.dart';

class ItemsRepository {

  Future<List<MapItemEntity>> getMapItems (double lat, double long) async {


    final response = await RemoteService.getMapItems(lat, long);

    List data =response.data;

    return data.map((v)=> MapItemEntity.fromApi(v)).toList();
  }

  Future<void> pickItem (String itemId, String userId) async {

    try {
      final response = await RemoteService.pickItem(itemId, userId);
    }
    catch (e) {
      print(e);
    }

  }

}