import 'package:bums_ar/core/colors.dart';
import 'package:bums_ar/view/main/auth/login/login_view_model.dart';
import 'package:bums_ar/view/main/profile/user_profile/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 300,),
            TextField(controller: _emailController,),
            SizedBox(height: 18,),
            TextField(controller: _passwordController,),
            SizedBox(height: 24,),
            BaseLongButton(onTap: () async {
              await vm.login();
            }, title: "Войти"),
          ],
        ),
      )),
    );
  }
}
