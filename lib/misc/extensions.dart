import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
    String contentText, {
    bool dismissOnTap = false,
  }) {
    hideSnackbar();
    final messenger = ScaffoldMessenger.of(this);
    return messenger.showSnackBar(SnackBar(content: Text(contentText)));
  }

  void hideSnackbar() => ScaffoldMessenger.of(this).hideCurrentSnackBar();
}
