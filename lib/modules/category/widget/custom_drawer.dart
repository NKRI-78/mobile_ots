import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/misc/colors.dart';

import '../../../misc/injections.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/dialog/custom_dialog.dart';
import '../../app/bloc/app_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset("assets/images/logo_primary.png", height: 175),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ListTile(
                        //   onTap: () {
                        //     context.pop();
                        //     // DashboardRoutes().go(context);
                        //   },
                        //   title: Center(
                        //     child: Text(
                        //       'Dashboard',
                        //       style: AppTextStyles.textStyleBold.copyWith(
                        //         color: AppColors.blackColor,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const Divider(
                          thickness: 1.5,
                          endIndent: 30,
                          indent: 30,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: CustomButton(
                borderRadius: 10,
                backgroundColor: AppColors.redColor,
                textColor: AppColors.whiteColor,
                label: "Keluar",
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => CustomDialog(
                      title: 'Apakah anda yakin ingin keluar dari Aplikasi?',
                      onConfirm: () {
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
