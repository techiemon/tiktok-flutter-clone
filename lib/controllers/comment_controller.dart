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
    getComment();
  }

  getComment() async {
    try {
      var wtf = postId.isEmpty ? "*" : postId;
      print(wtf);
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
    // DocumentSnapshot doc = await firestore
    //     .collection('videos')
    //     .doc(_postId)
    //     .collection('comments')
    //     .doc(id)
    //     .get();

    // if ((doc.data()! as dynamic)['likes'].contains(uid)) {
    //   await firestore
    //       .collection('videos')
    //       .doc(_postId)
    //       .collection('comments')
    //       .doc(id)
    //       .update({
    //     'likes': FieldValue.arrayRemove([uid]),
    //   });
    // } else {
    //   await firestore
    //       .collection('videos')
    //       .doc(_postId)
    //       .collection('comments')
    //       .doc(id)
    //       .update({
    //     'likes': FieldValue.arrayUnion([uid]),
    //   });
    // }
  }
}
