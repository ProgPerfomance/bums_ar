import 'package:bums_ar/core/services/remote_service.dart';

class NpcController {

  Future<void> getMapNpc (String userId, double lat, double long) async {

    final response = await RemoteService.getMapNpc(userId, lat, long);
  }

}