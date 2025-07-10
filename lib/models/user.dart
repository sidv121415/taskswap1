class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? phone;
  final String? photo;
  final String? bio;
  final bool isOnline;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.phone,
    this.photo,
    this.bio,
    this.isOnline = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      bio: json['bio'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'bio': bio,
      'isOnline': isOnline,
    };
  }
}