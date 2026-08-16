import '../../domain/entities/user.dart';

class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  final int id;
  final String name;
  final String username;
  final String email;

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, username: username, email: email);
  }
}
