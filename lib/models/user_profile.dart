class UserProfile {
  final String nickname; // nama panggilan anak
  final String email; // email orang tua/wali

  const UserProfile({required this.nickname, required this.email});

  Map<String, dynamic> toJson() => {'nickname': nickname, 'email': email};

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        nickname: json['nickname'] as String,
        email: json['email'] as String,
      );
}
