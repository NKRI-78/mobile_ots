import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ots/misc/logger.dart';

class AppError extends Equatable {
  final String? title;
  final String message;

  const AppError({required this.message, this.title});

  @override
  List<Object?> get props => [title, message];

  AppError copyWith({String? title, String? message}) {
    return AppError(
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'title': title, 'message': message};
  }

  factory AppError.fromJson(Map<String, dynamic> map) {
    return AppError(
      title: map['title'] != null ? map['title'] as String : null,
      message: map['message'] as String,
    );
  }
}

class ApiException implements Exception {
  final String? title;
  final String message;
  final Object? original;
  final StackTrace? stackTrace;

  ApiException({
    this.title,
    required this.message,
    this.original,
    this.stackTrace,
  });
}

class ParsingException implements Exception {
  final String title;
  final String message;
  final String? debugMessage;

  ParsingException({
    this.title = "Terjadi Kesalahan",
    this.message = "Data tidak dapat diproses. Silakan coba lagi.",
    this.debugMessage,
  });
}

class ErrorMapper {
  static ApiException map(Object error, StackTrace stackTrace) {
    final mappedError = _map(error, stackTrace);
    _log(mappedError);
    return mappedError;
  }

  static ApiException _map(Object error, StackTrace stackTrace) {
    if (error is ApiException) return error;

    if (error is SocketException) {
      return ApiException(
        title: "Koneksi Bermasalah",
        message:
            "Tidak dapat terhubung ke server. Periksa koneksi internet Anda dan coba lagi.",
        original: error,
        stackTrace: stackTrace,
      );
    }

    if (error is TimeoutException) {
      return ApiException(
        title: "Koneksi Lambat",
        message:
            "Permintaan memakan waktu terlalu lama. Periksa koneksi Anda dan coba lagi.",
        original: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return ApiException(
        title: "Terjadi Kesalahan",
        message: "Data dari server tidak dapat diproses. Silakan coba lagi.",
        original: error,
        stackTrace: stackTrace,
      );
    }

    if (error is ParsingException) {
      return ApiException(
        title: error.title,
        message: error.message,
        original: error,
        stackTrace: stackTrace,
      );
    }

    return ApiException(
      title: "Terjadi Kesalahan",
      message: "Terjadi kesalahan tidak terduga",
      original: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(ApiException e) {
    if (kReleaseMode) return;
    logger('''
[API ERROR]
Title   : ${e.title}
Message : ${e.message}
Original: ${e.original}
Stack   : ${e.stackTrace}
''');
  }
}
