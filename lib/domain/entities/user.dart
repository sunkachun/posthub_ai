import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  final int id;
  final String name;
  final String username;
  final String email;

  @override
  List<Object?> get props => [id, name, username, email];
}
