import 'package:equatable/equatable.dart';

class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class AuthUser extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;


  const AuthUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,

  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    // The token may be nested inside 'data' or at root
    final user = json['user'] ?? json;
    return AuthUser(
      id: user['id'],
      firstName: user['first_name'],
      lastName: user['last_name'],
      email: user['email'],

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
  };

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
