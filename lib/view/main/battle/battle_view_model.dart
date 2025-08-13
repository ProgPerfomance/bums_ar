import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class BattleViewModel extends ChangeNotifier {

  bool playerSeat = false;
  bool opponentSeat = false;

  int playerHealt  =100;
  int npcHealt  =100;


  void changePlayerSeat () {
    if(winBattleWindow || looseBattleWindow) {
      return;
    }
    playerSeat = !playerSeat;
    notifyListeners();
  }


  void playerUseMedicine () {
    if(winBattleWindow || looseBattleWindow) {
      return;
    }
    playerHealt +=30;
    notifyListeners();
  }

  void npcUseMedicine () {
    if(winBattleWindow || looseBattleWindow) {
      return;
    }
    npcHealt +=30;
    notifyListeners();
  }

  bool startBattleWindow = false;
  bool winBattleWindow = false;
  bool looseBattleWindow = false;

  void showStartBattleWindow () {
    startBattleWindow = true;
    notifyListeners();
  }

  void hideStartBattleWindow () {
    startBattleWindow = false;
    notifyListeners();
  }

  void showWinBattleWindow () {
    winBattleWindow = true;
    notifyListeners();
  }

  void hideWinBattleWindow () {
    winBattleWindow = false;
    notifyListeners();
  }

  void showLooseBattleWindow () {
    looseBattleWindow = true;
    notifyListeners();
  }

  void hideLooseBattleWindow () {
    looseBattleWindow = false;
    notifyListeners();
  }


  void winBattle () {
    showWinBattleWindow();
    print("победа");
  }
  void looseBattle () {
    showLooseBattleWindow();
    print("проигрыш");
  }

  void stopBattle () {
    timer?.cancel();
    notifyListeners();
  }
  Timer? timer;
  void startBattleAi () {
     timer =Timer.periodic(Duration(seconds: 1), (t) {
      if(opponentSeat == false) {
        npcShot();
      }
      if(npcHealt <= 0) {
        winBattle();
        timer?.cancel();
      }
      if(playerHealt <= 0) {
        looseBattle();
        print(playerHealt);
        timer?.cancel();
      }
      if(npcHealt < 40) {
        npcUseMedicine();
      }
    });
  }

  void npcShot() {
    if(winBattleWindow || looseBattleWindow) {
      return;
    }
    double chance = 0.3; // вероятность попадания (30%)
    int damage = 30;  // урон при попадании

    Random random = Random();
    double roll = random.nextDouble();
    if(playerSeat) {
      print("игрок за укрытием");
      return;
    }
    if (roll <= chance) {
      print("Противник Попал! Нанёс $damage урона.");
      playerHealt -= damage;
      if(playerHealt < 0) {
        playerHealt = 0;
      }
    } else {
      print("Противник: Промах!");
    }
    notifyListeners();
  }



  void playerShot() {
    if(winBattleWindow || looseBattleWindow) {
      return;
    }
    double chance = 0.3; // вероятность попадания (30%)
    int damage = 30;  // урон при попадании

    Random random = Random();
    double roll = random.nextDouble();
    if(opponentSeat) {
      print("противник за укрытием");
      return;
    }
    if (roll <= chance) {
      print("Попал! Нанёс $damage урона.");
      npcHealt -= damage;
      if(npcHealt < 0) {
        npcHealt = 0;
      }
    } else {
      print("Промах!");
    }
    notifyListeners();
  }


}