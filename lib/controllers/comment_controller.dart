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
      _comments = supabase.from('comments').stream(primaryKey: ['id']).map(
          (maps) => maps.map((map) => Comment.fromMap(map: map)).toList());
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        // DocumentSnapshot userDoc = await firestore
        //     .collection('users')
        //     .doc(authController.user.id)
        //     .get();
        // var allDocs = await firestore
        //     .collection('videos')
        //     .doc(_postId)
        //     .collection('comments')
        //     .get();
        // int len = allDocs.docs.length;

        // This is wrong, doesn't link to the video
        // TODO: Fix this
        final user = authController.user;
        final profile = authController.userProfile;
        await supabase.from('comments').insert({
          'comment': commentText.trim(),
          'username': profile!.username,
          'profilePhoto': profile.avatarUrl,
          'uid': user.id,
          'likes': [],
        });
        // Comment comment = Comment(
        //   username: (userDoc.data()! as dynamic)['name'],
        //   comment: commentText.trim(),
        //   datePublished: DateTime.now(),
        //   likes: [],
        //   profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
        //   uid: authController.user.id,
        //   id: 'Comment $len',
        // );
        // await firestore
        //     .collection('videos')
        //     .doc(_postId)
        //     .collection('comments')
        //     .doc('Comment $len')
        //     .set(
        //       comment.toJson(),
        //     );
        // DocumentSnapshot doc =
        //     await firestore.collection('videos').doc(_postId).get();
        // await firestore.collection('videos').doc(_postId).update({
        //   'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        // });
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
