class ProfileUser {
  String username;
  String avatarUrl;
  String? email;
  String id;
  List? followers;
  List? following;

  ProfileUser({
    required this.username,
    required this.email,
    required this.id,
    required this.avatarUrl,
    this.followers,
    this.following,
  });

  factory ProfileUser.fromMap({required Map<String, dynamic> map}) {
    return ProfileUser(
      email: map['email'],
      avatarUrl: map['avatar_url'],
      id: map['id'],
      username: map['username'],
      followers: map['followers'] ?? [],
      following: map['following'] ?? [],
    );
  }
}
