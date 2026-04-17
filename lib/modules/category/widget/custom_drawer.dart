import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/socket.dart';
import 'package:mobile_ots/repositories/auth_repository/models/auth_models.dart';

import '../../../misc/injections.dart';
import '../../../widgets/dialog/custom_dialog.dart';
import '../../app/bloc/app_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final top = context.mediaQuery.padding.top;
    final bottom = context.mediaQuery.padding.bottom;
    final padding = EdgeInsets.only(top: top, bottom: bottom + 24);

    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            // logo
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/logo.png",
                height: 90,
                width: 120,
              ),
            ),

            BlocSelector<AppBloc, AppState, UserModel?>(
              selector: (s) => s.user,
              builder: (context, user) {
                if (user == null) return SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.theme.primaryColor,
                      child: Text("A", style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(user.name),
                  ),
                );
              },
            ),

            const Spacer(),

            // logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(4),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => CustomDialog(
                      title: 'Apakah anda yakin ingin keluar dari Aplikasi?',
                      onConfirm: () {
                        SocketService().disconnect();
                        getIt<AppBloc>().add(SetUserLogout());
                      },
                      onCancel: () {
                        context.pop();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
