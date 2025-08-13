import 'package:bums_ar/core/colors.dart';
import 'package:bums_ar/view/main/battle/battle_view_model.dart';
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
            decoration: BoxDecoration(color: AppColors.mainBlue),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(height: vm.playerSeat ? 50 : 100, width: 50, color: Colors.green),
                          SizedBox(width: 24),
                          Container(height: 50, width: 30, color: Colors.grey),
                          Spacer(),
                          Container(height: 50, width: 30, color: Colors.grey),
                          SizedBox(width: 24),
                          Container(height: vm.opponentSeat ? 50 : 100, width: 50, color: Colors.green),
                        ],
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
                                  color: Colors.grey, // фон (потерянное здоровье)
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width / 2.3) * (vm.playerHealt / 100),
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
                                width: (MediaQuery.of(context).size.width / 2.3) * (vm.npcHealt / 100),
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
                    Positioned(bottom: 30, child: BattleButton(onTap: (){
                      vm.playerUseMedicine();
                    },)),
                    Positioned(bottom: 75, left: 48, child: BattleButton(onTap: (){
                      vm.changePlayerSeat();
                    },)),
                    Positioned(
                      bottom: 115,
                      height: 58,
                      width: 58,
                      child: BattleButton(onTap: () {
                        vm.playerShot();
                      },),
                    ),

                  ],
                ),
              ),
            ),
          ),
          if(vm.startBattleWindow)
            StartBattleSheet(),
          if(vm.winBattleWindow)
            Center(child: Text("Победа",style: TextStyle(color: Colors.green)),),
          if(vm.looseBattleWindow)
            Center(child: Text("Поражение",style: TextStyle(color: Colors.red),),)
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

class BattleButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;
  const BattleButton({super.key, this.width = 48, this.height = 48, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white.withAlpha(80),
          border: Border.all(color: Colors.white.withAlpha(183)),
        ),
      ),
    );
  }
}


class StartBattleSheet extends StatelessWidget {
  const StartBattleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BattleViewModel>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(173),
      ),
      child: Center(
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.mainBlue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 48,),
                Text("Вы хотите начать бой?",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width / 2.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withAlpha(128),
                        ),
                        child: Center(
                          child: Text("Скрыться", style: TextStyle(color: Colors.white,),),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        vm.startBattleAi();
                        vm.hideStartBattleWindow();
                      },
                      child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width / 2.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withAlpha(128),
                        ),
                        child: Center(
                          child: Text("Начать", style: TextStyle(color: Colors.white,),),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
