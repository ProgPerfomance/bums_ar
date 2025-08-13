import 'package:bums_ar/core/images.dart';
import 'package:bums_ar/view/main/battle/battle_view_model.dart';
import 'package:bums_ar/view/main/battle/widgets/battle_button.dart';
import 'package:bums_ar/view/main/battle/widgets/start_battle_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleView extends StatefulWidget {
  const BattleView({super.key});

  @override
  State<BattleView> createState() => _BattleViewState();
}

class _BattleViewState extends State<BattleView> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BattleViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.battleBg),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 150, // высота всей линии
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.end, // прижимаем всё к низу
                          children: [
                            // Игрок
                            SizedBox(
                              height: 150,
                              width: 90,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          vm.playerSeat
                                              ? AppImages.personSeat
                                              : AppImages.personStay,
                                        ),
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Image.asset(
                                      AppImages.scarL,
                                      fit: BoxFit.contain,
                                      width: 90,
                                    ),
                                    left: 8,
                                    bottom: vm.playerSeat ? 34 : 70,
                                  ),
                                ],
                              ),
                            ),

                            // Баррикада справа
                            Container(
                              height: 70,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.barricadeRight),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Баррикада слева
                            Container(
                              height: 70,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.barricadeLeft),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            // Противник
                            Transform(
                              alignment: Alignment.center,
                              transform:
                                  Matrix4.identity()..scale(
                                    -1.0,
                                    1.0,
                                    1.0,
                                  ), // отражение по горизонтали
                              child: SizedBox(
                                height: 150,
                                width: 90,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            vm.opponentSeat
                                                ? AppImages.personSeat
                                                : AppImages.personStay,
                                          ),
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Image.asset(
                                        AppImages.scarL,
                                        fit: BoxFit.contain,
                                        width: 90,
                                      ),
                                      left: 8,
                                      bottom: vm.opponentSeat ? 34 : 70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.5, 0.4),
                      child: Row(
                        children: [
                          // Player HP bar
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey, // фон (потерянное здоровье)
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width / 2.3) *
                                    (vm.playerHealt / 100),
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red, // текущее здоровье
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ],
                          ),

                          Spacer(),

                          // NPC HP bar
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width / 2.3) *
                                    (vm.npcHealt / 100),
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: BattleButton(
                        onTap: () {
                          vm.playerUseMedicine();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(AppImages.medicalKit),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 75,
                      left: 48,
                      child: BattleButton(
                        onTap: () {
                          vm.changePlayerSeat();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(vm.playerSeat ? AppImages.iconSeat : AppImages.iconState),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 115,
                      height: 58,
                      width: 58,
                      child: BattleButton(
                        onTap: () {
                          vm.firePlayer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (vm.startBattleWindow) StartBattleSheet(),
          if (vm.winBattleWindow)
            Center(
              child: Text("Победа", style: TextStyle(color: Colors.green)),
            ),
          if (vm.looseBattleWindow)
            Center(
              child: Text("Поражение", style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    final vm = Provider.of<BattleViewModel>(context, listen: false);
    vm.showStartBattleWindow();
    super.initState();
  }
}
