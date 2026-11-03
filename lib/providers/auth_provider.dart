import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class _PendingRegistration {
  String nickname;
  String email;
  final String passwordHash;
  String code;
  _PendingRegistration(this.nickname, this.email, this.passwordHash, this.code);
}

/// Mengelola registrasi, verifikasi email, login, dan sesi.
///
/// CATATAN: ini implementasi LOKAL untuk prototipe (data disimpan di
/// SharedPreferences, kode verifikasi hanya "disimulasikan" dan ditampilkan
/// di aplikasi). Untuk produksi, ganti isi method di bawah dengan panggilan
/// ke backend / Firebase Auth tanpa mengubah layar-layarnya.
class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'qalamku_users';
  static const _sessionKey = 'qalamku_session';
  static const resendSeconds = 45;

  UserProfile? currentUser;
  _PendingRegistration? _pending;

  bool get isLoggedIn => currentUser != null;
  String? get pendingEmail => _pending?.email;
  String? get pendingNickname => _pending?.nickname;
  bool get hasPending => _pending != null;

  String _normalize(String email) => email.trim().toLowerCase();

  String _hash(String email, String password) =>
      sha256.convert(utf8.encode('${_normalize(email)}::$password')).toString();

  String _newCode() => (100000 + Random.secure().nextInt(900000)).toString();

  Future<Map<String, dynamic>> _readUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _writeUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// Dipanggil saat aplikasi dibuka: pulihkan sesi login terakhir.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_sessionKey);
    if (email == null) return;
    final users = await _readUsers();
    final data = users[email];
    if (data != null) {
      currentUser =
          UserProfile.fromJson(Map<String, dynamic>.from(data['profile'] as Map));
    }
  }

  /// Langkah 1 registrasi. Mengembalikan kode (hanya untuk simulasi email).
  Future<String> register({
    required String nickname,
    required String email,
    required String password,
  }) async {
    final users = await _readUsers();
    final key = _normalize(email);
    if (users.containsKey(key)) {
      throw AuthException('Email ini sudah terdaftar. Silakan masuk.');
    }
    final code = _newCode();
    _pending = _PendingRegistration(
        nickname.trim(), key, _hash(key, password), code);
    notifyListeners();
    return code;
  }

  /// Kirim ulang kode baru. Mengembalikan kode (simulasi).
  String resendCode() {
    final p = _pending;
    if (p == null) throw AuthException('Tidak ada pendaftaran yang berjalan.');
    p.code = _newCode();
    return p.code;
  }

  /// Ganti email tujuan kode. Mengembalikan kode baru (simulasi).
  Future<String> changePendingEmail(String newEmail) async {
    final p = _pending;
    if (p == null) throw AuthException('Tidak ada pendaftaran yang berjalan.');
    final key = _normalize(newEmail);
    final users = await _readUsers();
    if (users.containsKey(key)) {
      throw AuthException('Email ini sudah terdaftar.');
    }
    p.email = key;
    p.code = _newCode();
    notifyListeners();
    return p.code;
  }

  /// Langkah 2: cek kode 6 angka. Jika benar, akun dibuat dan pengguna masuk.
  Future<void> verify(String code) async {
    final p = _pending;
    if (p == null) throw AuthException('Tidak ada pendaftaran yang berjalan.');
    if (code.length != 6 || code != p.code) {
      throw AuthException('Kode salah atau belum lengkap. Coba lagi ya.');
    }
    final profile = UserProfile(nickname: p.nickname, email: p.email);
    final users = await _readUsers();
    users[p.email] = {
      'passwordHash': p.passwordHash,
      'profile': profile.toJson(),
    };
    await _writeUsers(users);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, p.email);
    currentUser = profile;
    _pending = null;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final users = await _readUsers();
    final key = _normalize(email);
    final data = users[key];
    if (data == null || data['passwordHash'] != _hash(key, password)) {
      throw AuthException('Email atau kata sandi salah.');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, key);
    currentUser =
        UserProfile.fromJson(Map<String, dynamic>.from(data['profile'] as Map));
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    currentUser = null;
    notifyListeners();
  }

  void cancelPending() {
    _pending = null;
    notifyListeners();
  }
}
