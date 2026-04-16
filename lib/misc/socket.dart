// ignore_for_file: library_prefixes

import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef SocketEventCallback = void Function(dynamic data);

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  static const String _baseUrl =
      'https://socket-merchant-tunaipay.langitdigital78.com';

  IO.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  // ─── Connection ───────────────────────────────────────────────────────────

  /// Inisialisasi dan hubungkan socket.
  /// [token]  : Bearer token untuk autentikasi (opsional).
  /// [query]  : Query params tambahan yang dikirim saat handshake.
  /// [path]   : Custom socket path, default '/socket.io'.
  void connect({String? token, Map<String, dynamic>? query, String? path}) {
    if (isConnected) {
      log('[Socket] Sudah terhubung, skip connect.', name: 'SocketService');
      return;
    }

    log(
      '\n┌─────────────────────────────────────────\n'
      '│ [Socket] Memulai koneksi...\n'
      '│  Base URL : $_baseUrl\n'
      '│  Path     : ${path ?? 'null'}\n'
      '│  Token    : ${token != null ? '${token.substring(0, token.length.clamp(0, 20))}...' : 'null'}\n'
      '│  Query    : ${query ?? '{}'}\n'
      '│  Headers  : ${token != null ? '{Authorization: Bearer ${token.substring(0, token.length.clamp(0, 10))}...}' : '{}'}\n'
      '└─────────────────────────────────────────',
      name: 'SocketService',
    );

    final builder = IO.OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders(
          token != null ? {'Authorization': 'Bearer $token'} : {},
        )
        .setQuery(query ?? {})
        .disableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(5)
        .setReconnectionDelay(2000);

    if (path != null) builder.setPath(path);

    _socket = IO.io(_baseUrl, builder.build());

    _registerDefaultListeners();
    _socket!.connect();
  }

  /// Config with user id
  void connectWithUserId(String uid) {
    connect(query: {"user_id": uid});
  }

  /// Putuskan koneksi dan bersihkan socket.
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    log('[Socket] Terputus.', name: 'SocketService');
  }

  // ─── Default Listeners ────────────────────────────────────────────────────

  void _registerDefaultListeners() {
    _socket!
      ..onConnect((_) {
        log('[Socket] Terhubung — id: ${_socket?.id}', name: 'SocketService');
      })
      ..onDisconnect((reason) {
        log('[Socket] Disconnect: $reason', name: 'SocketService');
      })
      ..onConnectError((err) {
        log('[Socket] Connect error: $err', name: 'SocketService');
      })
      ..onError((err) {
        log('[Socket] Error: $err', name: 'SocketService');
      })
      ..onReconnect((attempt) {
        log('[Socket] Reconnect attempt #$attempt', name: 'SocketService');
      })
      ..onReconnectFailed((_) {
        log('[Socket] Reconnect gagal.', name: 'SocketService');
      });
  }

  // ─── Emit ─────────────────────────────────────────────────────────────────

  /// Kirim event ke server.
  void emit(String event, [dynamic data]) {
    if (!isConnected) {
      log(
        '[Socket] Tidak terhubung, gagal emit "$event".',
        name: 'SocketService',
      );
      return;
    }
    _socket!.emit(event, data);
    log('[Socket] Emit "$event": $data', name: 'SocketService');
  }

  /// Kirim event dan tunggu acknowledgement dari server.
  void emitWithAck(
    String event,
    dynamic data, {
    required void Function(dynamic ack) onAck,
  }) {
    if (!isConnected) {
      log(
        '[Socket] Tidak terhubung, gagal emitWithAck "$event".',
        name: 'SocketService',
      );
      return;
    }
    _socket!.emitWithAck(event, data, ack: onAck);
    log('[Socket] EmitWithAck "$event": $data', name: 'SocketService');
  }

  // ─── Listen ───────────────────────────────────────────────────────────────

  /// Daftarkan listener untuk event tertentu.
  void on(String event, SocketEventCallback callback) {
    _socket?.on(event, callback);
    log('[Socket] Listening on "$event"', name: 'SocketService');
  }

  /// Daftarkan listener yang hanya dipanggil sekali.
  void once(String event, SocketEventCallback callback) {
    _socket?.once(event, callback);
    log('[Socket] Once on "$event"', name: 'SocketService');
  }

  /// Hapus listener untuk event tertentu.
  void off(String event, [SocketEventCallback? callback]) {
    _socket?.off(event, callback);
    log('[Socket] Off "$event"', name: 'SocketService');
  }

  /// Hapus semua listener.
  void offAll() {
    _socket?.clearListeners();
    log('[Socket] Semua listener dihapus.', name: 'SocketService');
  }

  // ─── Room ─────────────────────────────────────────────────────────────────

  /// Bergabung ke room tertentu (konvensi emit 'join').
  void joinRoom(String room) => emit('join', {'room': room});

  /// Keluar dari room tertentu (konvensi emit 'leave').
  void leaveRoom(String room) => emit('leave', {'room': room});
}
