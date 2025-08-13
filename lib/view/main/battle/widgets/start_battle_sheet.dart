import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors.dart';
import '../battle_view_model.dart';


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


