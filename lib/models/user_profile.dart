class ProfileUser {
  String username;
  String avatarUrl;
  String? email;
  String id;

  ProfileUser({
    required this.username,
    required this.email,
    required this.id,
    required this.avatarUrl,
  });

  factory ProfileUser.fromMap({required Map<String, dynamic> map}) {
    return ProfileUser(
      email: map['email'],
      avatarUrl: map['avatar_url'],
      id: map['id'],
      username: map['username'],
    );
  }
}
