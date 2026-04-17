import 'dart:developer';

import 'package:flutter/foundation.dart';

void logger(
  String message, {
  String? name,
  bool enableRelease = true,
  StackTrace? stackTrace,
}) {
  if (kDebugMode) {
    log(message, name: name ?? "", stackTrace: stackTrace);
  } else if (kReleaseMode && enableRelease) {
    // ignore: avoid_print
    print("${name ?? ""} $message");
  }
}
