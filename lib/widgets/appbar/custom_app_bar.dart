import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.titleText,
    this.backgroundColor,
    this.actions = const <Widget>[],
    this.automaticallyImplyLeading = true,
  });

  final String? titleText;
  final List<Widget> actions;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleWidget = titleText != null ? Text(titleText!) : null;
    return AppBar(
      title: titleWidget,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      centerTitle: true,
      actions: actions,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      actionsPadding: EdgeInsets.only(right: 6),
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
