class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromGoogleSignIn(dynamic user) {
    return UserModel(
      id: user.id ?? '',
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoUrl,
    );
  }
}
