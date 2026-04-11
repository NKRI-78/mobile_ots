import 'package:flutter/material.dart';

class KeyboardDismisser extends StatelessWidget {
  final Widget child;
  final bool dismissOnTapOutside;
  final bool dismissOnDrag;

  const KeyboardDismisser({
    super.key,
    required this.child,
    this.dismissOnTapOutside = true,
    this.dismissOnDrag = false,
  });

  void _dismissKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    if (dismissOnTapOutside) {
      current = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _dismissKeyboard(context),
        child: current,
      );
    }

    if (dismissOnDrag) {
      current = NotificationListener<UserScrollNotification>(
        onNotification: (_) {
          _dismissKeyboard(context);
          return false;
        },
        child: current,
      );
    }

    return current;
  }
}
