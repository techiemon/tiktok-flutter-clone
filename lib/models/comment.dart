class Comment {
  String username;
  String comment;
  String datePublished;
  int likes;
  String profilePhoto;
  int uid;
  int id;

  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
  });

  // Map<String, dynamic> toJson() => {
  //       'username': username,
  //       'comment': comment,
  //       'datePublished': datePublished,
  //       'likes': likes,
  //       'profilePhoto': profilePhoto,
  //       'uid': uid,
  //       'id': id,
  //     };

  factory Comment.fromMap({required Map<String, dynamic> map}) {
    return Comment(
      username: map['username'],
      comment: map['comment'],
      datePublished: map['created_at'],
      likes: map['likes'],
      profilePhoto: map['profilePhoto'],
      uid: map['uid'],
      id: map['id'],
    );
  }
}
