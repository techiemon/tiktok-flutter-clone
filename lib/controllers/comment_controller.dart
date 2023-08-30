import 'package:get/get.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/models/comment.dart';

class CommentController extends GetxController {
  late Stream<List<Comment>> _comments;
  Stream<List<Comment>> get comments => _comments;

  String _postId = "";
  String get postId => _postId;

  updatePostId(String id) {
    _postId = id;
    getComments();
  }

  getComments() async {
    try {
      _comments = supabase
          .from('comments')
          .stream(primaryKey: ['id'])
          .eq('uid', postId)
          .map((maps) => maps.map((map) => Comment.fromMap(map: map)).toList());
      update();
    } catch (e) {
      Get.snackbar(
        'Error getting comments',
        e.toString(),
      );
    }
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        final profile = authController.userProfile;
        await supabase.from('comments').insert({
          'comment': commentText.trim(),
          'username': profile!.username,
          'profilePhoto': profile.avatarUrl,
          'uid': postId,
          'likes': [],
        });
        final video =
            await supabase.from('videos').select().eq('id', postId).single();

        await supabase.from('videos').update({
          'commentCount': int.parse(video['commentCount']) + 1,
        }).eq('id', postId);
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = authController.user.id;
    final comment = await supabase
        .from('comments')
        .select()
        .eq('id', int.parse(id))
        .single();

    final commentLikes = comment?['likes'] ?? [];
    var likes = [];
    commentLikes.forEach((element) {
      likes.add(element);
    });

    if (commentLikes.contains(uid)) {
      likes.remove(uid);
      try {
        // TODO: No RLP on this.
        await supabase
            .from('comments')
            .update({'likes': likes}).eq('id', int.parse(id));
      } on Exception catch (e) {
        Get.snackbar(
          'Error updating likes',
          e.toString(),
        );
      }
    } else {
      likes.add(uid);
      try {
        await supabase
            .from('comments')
            .update({'likes': likes}).eq('id', int.parse(id));
      } on Exception catch (e) {
        Get.snackbar(
          'Error updating likes',
          e.toString(),
        );
      }
    }
  }
}
