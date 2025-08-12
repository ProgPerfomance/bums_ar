import 'package:bums_ar/view/main/auth/login/login_view.dart';
import 'package:bums_ar/view/main/map/map_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loading_view_model.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoadingViewModel>();

    return FutureBuilder<bool>(
      future: vm.ensureUserLoaded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if(snapshot.data == true) {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => MapView()), (
                  v) => false);
            }
            else {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => LoginView()), (
                  v) => false);
            }
          });
          return const SizedBox.shrink();
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
