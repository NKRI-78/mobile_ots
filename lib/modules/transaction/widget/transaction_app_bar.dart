import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/modules/app/bloc/app_bloc.dart';

class SliverTransactionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SliverTransactionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      title: BlocSelector<AppBloc, AppState, String>(
        selector: (s) => s.user?.name ?? "",
        builder: (context, username) {
          if (username.isEmpty) {
            return Image.asset("assets/images/logo.png", width: 90, height: 30);
          }
          return Text.rich(
            TextSpan(
              text: 'Halo, ',
              children: [
                TextSpan(
                  text: username,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          );
        },
      ),
      pinned: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
