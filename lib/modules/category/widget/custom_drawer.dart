import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/socket.dart';
import 'package:mobile_ots/router/builder.dart';

import '../../../misc/injections.dart';
import '../../../widgets/dialog/custom_dialog.dart';
import '../../app/bloc/app_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _closeDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final top = context.mediaQuery.padding.top;
    final bottom = context.mediaQuery.padding.bottom;
    final padding = EdgeInsets.only(top: top, bottom: bottom + 24);

    return Drawer(
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
              child: Image.asset("assets/images/logo_primary.png", height: 175),
            ),

            const SizedBox(height: 24),

            // logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: context.theme.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: const Text("Daftar Transaksi"),
                trailing: const Icon(Icons.chevron_right, size: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(4),
                ),
                onTap: () {
                  _closeDrawer(context);
                  TransactionsRoutes().go(context);
                },
              ),
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
