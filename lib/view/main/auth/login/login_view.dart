import 'package:bums_ar/core/colors.dart';
import 'package:bums_ar/view/main/auth/login/login_view_model.dart';
import 'package:bums_ar/view/main/map/map_view.dart';
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
            AppTextField(controller: _emailController,hintText: "Email",),
            SizedBox(height: 18,),
            AppTextField(controller: _passwordController,hintText: "Пароль",),
            SizedBox(height: 24,),
            BaseLongButton(onTap: () async {
             bool success = await vm.login(_emailController.text,_passwordController.text);
             if(success == true) {
               Navigator.push(context, MaterialPageRoute(builder: (context)=> MapView()));
             }
             else {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Неверный логин или пароль")));
             }
            }, title: "Войти"),
          ],
        ),
      )),
    );
  }
}


class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const AppTextField({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
