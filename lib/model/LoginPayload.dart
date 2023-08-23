class LoginPayload {
  LoginPayload({required this.email, required this.password});
  String? email;
  String? password;
  LoginPayload copyWith({String? email, String? password}) => LoginPayload(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
