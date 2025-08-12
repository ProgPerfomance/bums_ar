import 'package:bums_ar/core/colors.dart';
import 'package:bums_ar/view/main/profile/user_profile/user_profile_view_model.dart';
import 'package:bums_ar/view/main/shop/bottle_shop/bottle_shop_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserProfileViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShopExitButton(),
              SizedBox(height: 300),
              BaseLongButton(
                onTap: () async {
                  await vm.logout();
                },
                title: "Выйти",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseLongButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  const BaseLongButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withAlpha(30),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
