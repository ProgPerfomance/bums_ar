import 'package:bums_ar/core/services/remote_service.dart';
import 'package:bums_ar/domain/entities/npc_entity.dart';

class NpcRepository {

  Future<List<NpcEntity>> getMapNpc (String userId, double lat, double long) async {

    final response = await RemoteService.getMapNpc(userId, lat, long);

    List data =response.data;
    return data.map((v)=> NpcEntity.fromApi(v)).toList();
  }

}