class Video {
  String username;
  String uid;
  int id;
  int likes;
  String commentCount;
  String shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.profilePhoto,
    required this.thumbnail,
  });

  factory Video.fromMap({required Map<String, dynamic> map}) {
    return Video(
      username: map['username'],
      uid: map['uid'],
      id: map['id'],
      likes: map['likes'],
      commentCount: map['commentCount'],
      shareCount: map['shareCount'],
      songName: map['songName'],
      caption: map['caption'],
      videoUrl: map['videoUrl'],
      profilePhoto: map['profilePhoto'],
      thumbnail: map['thumbnail'],
    );
  }
}
