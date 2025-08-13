import 'dart:async';
import 'dart:math';
import 'package:bums_ar/main.dart';
import 'package:bums_ar/view/main/battle/widgets/tracer_bullet.dart';
import 'package:flutter/material.dart';
import '../../../data/repository/user_repository.dart';
import '../../../service_locator.dart';
import 'battle_view.dart';


class BattleViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();
  bool playerSeat = false;
  bool opponentSeat = false;

  int get playerHealt => _userRepository.activeUser.stats.heal.toInt();
  int npcHealt = 100;

  // ======== ВЫСТРЕЛ ЧЕРЕЗ OVERLAY (напрямую из VM) ========
  void _spawnTracer({required bool fromLeft, required bool miss}) {
    final overlay = navKey.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => TracerBullet(
        miss: miss,
        fromLeft: fromLeft,
        onDone: () {
          entry.remove(); // удалить как долетит
        },
      ),
    );

    overlay.insert(entry);
  }

  void firePlayer() {
    if (winBattleWindow || looseBattleWindow || playerSeat) return;
    bool? miss = playerShot();
    if(miss == null) return;
    _spawnTracer(fromLeft: true,miss: !miss);
  }

  void fireNpc() {
    if (winBattleWindow || looseBattleWindow || opponentSeat) return;
    bool? miss = npcShot();
    if(miss == null) return;
    _spawnTracer(fromLeft: false,miss: !miss);

  }

  // ======== Остальная логика как у тебя ========
  void changePlayerSeat() {
    if (winBattleWindow || looseBattleWindow) return;
    playerSeat = !playerSeat;
    notifyListeners();
  }

  void playerUseMedicine() {
    if (winBattleWindow || looseBattleWindow) return;
    _userRepository.healUser(30);
    notifyListeners();
  }

  void npcUseMedicine() {
    if (winBattleWindow || looseBattleWindow) return;
    npcHealt += 30;
    notifyListeners();
  }

  bool startBattleWindow = false;
  bool winBattleWindow = false;
  bool looseBattleWindow = false;

  void showStartBattleWindow() { startBattleWindow = true; notifyListeners(); }
  void hideStartBattleWindow() { startBattleWindow = false; notifyListeners(); }
  void showWinBattleWindow() { winBattleWindow = true; notifyListeners(); }
  void hideWinBattleWindow() { winBattleWindow = false; notifyListeners(); }
  void showLooseBattleWindow() { looseBattleWindow = true; notifyListeners(); }
  void hideLooseBattleWindow() { looseBattleWindow = false; notifyListeners(); }

  void winBattle() { showWinBattleWindow(); }
  void looseBattle() { showLooseBattleWindow(); }

  Timer? timer;
  void stopBattle() { timer?.cancel(); notifyListeners(); }

  void startBattleAi() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!opponentSeat) {
        fireNpc(); // трассер + логика
      }
      if (npcHealt <= 0) {
        winBattle(); timer?.cancel();
      }
      if (playerHealt <= 0) {
        looseBattle(); timer?.cancel();
      }
      if (npcHealt < 40) {
        npcUseMedicine();
      }
    });
  }

  bool? npcShot() {
    if (winBattleWindow || looseBattleWindow) return null;
    const chance = 0.3;
    const damage = 0;
    final r = Random();
    bool addDamage = r.nextDouble() <= chance;
    if (playerSeat) return null;
    if (addDamage) {
      _userRepository.damageUser(damage);
    }
    notifyListeners();
    return addDamage;
  }

  bool? playerShot() {
    if (winBattleWindow || looseBattleWindow) return null;
    const chance = 0.3;
    const damage = 30;
    final r = Random();
    bool addDamage = r.nextDouble() <= chance;
    if (opponentSeat) return null;
    if (addDamage) {
      npcHealt -= damage;
      if (npcHealt < 0) npcHealt = 0;
    }
    notifyListeners();
    return addDamage;
  }
}
