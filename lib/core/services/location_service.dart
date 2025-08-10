import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<Position>? _sub;

  /// Проверяем включены ли сервисы и даём runtime-разрешение
  Future<void> ensurePermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Пользователь сам включает сервис в настройках — можно показать диалог выше по уровню
      throw const LocationException('Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationException('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException('Location permission permanently denied');
    }
  }

  /// Текущая позиция (однократно)
  Future<Position> getCurrent({bool highAccuracy = true}) async {
    await ensurePermissions();
    return Geolocator.getCurrentPosition(
      desiredAccuracy: highAccuracy ? LocationAccuracy.best : LocationAccuracy.low,
      timeLimit: const Duration(seconds: 8),
    );
  }

  /// Последняя кэшированная позиция (может быть null)
  Future<Position?> getLastKnown() => Geolocator.getLastKnownPosition();

  /// Стрим позиций (для “следить за пользователем на карте”)
  /// Стрим позиций (для “следить за пользователем на карте”)
  Stream<Position> watch({
    bool highAccuracy = true,
    int distanceFilter = 5, // срабатывать каждые X метров
    Duration interval = const Duration(seconds: 2),
  }) async* {
    await ensurePermissions();
    final settings = LocationSettings(
      accuracy: highAccuracy ? LocationAccuracy.best : LocationAccuracy.low,
      distanceFilter: distanceFilter,
    );
    yield* Geolocator.getPositionStream(locationSettings: settings);
  }


  /// Запуск фонового слежения с колбэком (если нужно держать подписку внутри сервиса)
  Future<void> startWatch(
      void Function(Position) onData, {
        bool highAccuracy = true,
        int meters = 5,
      }) async {
    await ensurePermissions();
    _sub?.cancel();
    _sub = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: highAccuracy ? LocationAccuracy.best : LocationAccuracy.low,
        distanceFilter: meters,
      ),
    ).listen(onData);
  }


  Future<void> stopWatch() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> openAppSettings() => Geolocator.openAppSettings();
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
  @override
  String toString() => 'LocationException: $message';
}
