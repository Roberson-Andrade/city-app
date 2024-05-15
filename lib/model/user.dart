class User {
  final String id;
  final String name;
  final String email;
  final String? avatarImage;

  User(
      {required this.id,
      required this.email,
      required this.name,
      this.avatarImage});

  User.fromJson(Map<String, Object?> json)
      : this(
            id: json['id'] as String,
            name: json['name'] as String,
            email: json['email'] as String,
            avatarImage: json['avatarImage'] as String?);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarImage,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatarImage: avatarImage ?? this.avatarImage);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'email': email, 'avatarImage': avatarImage};
  }
}
