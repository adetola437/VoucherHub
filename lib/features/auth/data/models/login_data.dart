import 'package:equatable/equatable.dart';

import 'auth_models.dart';

class LoginResponse extends Equatable {
  final String accessToken;
  final DateTime expiresAtUtc;
  final AuthUser user;

  const LoginResponse({
    required this.accessToken,
    required this.expiresAtUtc,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String? ?? '',
      expiresAtUtc: json['expiresAtUtc'] != null
          ? DateTime.parse(json['expiresAtUtc'] as String)
          : DateTime.now(),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'expiresAtUtc': expiresAtUtc.toIso8601String(),
        'user': user.toJson(),
      };

  @override
  List<Object?> get props => [accessToken, expiresAtUtc, user];
}

class User extends Equatable {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? json['first_name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? json['last_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      };

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
