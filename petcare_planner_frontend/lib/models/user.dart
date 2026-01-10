class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    this.profileImageUrl,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? token,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      token: json['token'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'profileImageUrl': profileImageUrl,
    };
  }
}
