/// Validasi form. Mengembalikan pesan kesalahan, atau null jika valid.
class Validators {
  Validators._();

  static const minPasswordLength = 8;

  static String? nickname(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Nama panggilan anak wajib diisi.';
    return null;
  }

  static String? email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email wajib diisi.';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!ok) return 'Format email belum benar.';
    return null;
  }

  static String? password(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Kata sandi wajib diisi.';
    if (value.length < minPasswordLength) {
      return 'Kata sandi minimal $minPasswordLength karakter.';
    }
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if ((v ?? '').isEmpty) return 'Ulangi kata sandi dulu ya.';
    if (v != original) return 'Kata sandi tidak sama.';
    return null;
  }

  static String? loginPassword(String? v) {
    if ((v ?? '').isEmpty) return 'Kata sandi wajib diisi.';
    return null;
  }
}
