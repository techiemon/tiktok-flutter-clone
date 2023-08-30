import 'dart:convert';

import 'package:get/get.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/models/video.dart';

class VideoController extends GetxController {
  late Stream<List<Video>> _videos;

  Stream<List<Video>> get videos => _videos;

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      _videos = supabase.from('videos').stream(primaryKey: ['id']).map(
          (maps) => maps.map((map) => Video.fromMap(map: map)).toList());
    } catch (e) {
      Get.snackbar(
        'Error getting videos',
        e.toString(),
      );
    }
  }

  getCommentCount(int videoID) async {
    final comments = await supabase
        .from('videos')
        .select()
        .eq('uid', videoID as int)
        .then((value) => value.length);
    // var comments = video['comments'] ?? [];
    return comments.length.toString();
  }

  likeVideo(String id) async {
    final video = await supabase.from('videos').select().eq('id', id).single();
    var uid = authController.user.id;
    var videoData = video['likes'] ?? [];
    final likes = [];
    videoData.forEach((element) {
      likes.add(element);
    });

    if (likes.contains(uid)) {
      likes.remove(uid);
      var newLikes = likes;
      await supabase.from('videos').update({'likes': newLikes}).eq('id', id);
    } else {
      likes.add(uid);
      var newLikes = likes;
      await supabase.from('videos').update({'likes': newLikes}).eq('id', id);
    }
  }
}
