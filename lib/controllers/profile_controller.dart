import 'package:get/get.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/models/user_profile.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    // final user_id = _uid.value.isNo ? _uid.value : authController.user.id;
    var myVideos = await supabase.from('videos').select().eq('uid', _uid.value);

    for (int i = 0; i < myVideos.length; i++) {
      thumbnails.add((myVideos[i] as dynamic)['thumbnail']);
    }

    final profile =
        await supabase.from('profiles').select().eq('id', _uid.value).single();

    final profileData = ProfileUser.fromMap(map: profile);
    String profilePhoto = profileData.avatarUrl;
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos) {
      likes += (item['likes'] as List).length;
    }
    // var followerDoc = await firestore
    //     .collection('users')
    //     .doc(_uid.value)
    //     .collection('followers')
    //     .get();
    // var followingDoc = await firestore
    //     .collection('users')
    //     .doc(_uid.value)
    //     .collection('following')
    //     .get();
    // followers = followerDoc.docs.length;
    // following = followingDoc.docs.length;

    // firestore
    //     .collection('users')
    //     .doc(_uid.value)
    //     .collection('followers')
    //     .doc(authController.user.id)
    //     .get()
    //     .then((value) {
    //   if (value.exists) {
    //     isFollowing = true;
    //   } else {
    //     isFollowing = false;
    //   }
    // });

    // _user.value = {
    //   'followers': followers.toString(),
    //   'following': following.toString(),
    //   'isFollowing': isFollowing,
    //   'likes': likes.toString(),
    //   'profilePhoto': profilePhoto,
    //   'name': name,
    //   'thumbnails': thumbnails,
    // };
    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': false,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': profileData.username,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = null; // TODO
    // var doc = await firestore
    //     .collection('users')
    //     .doc(_uid.value)
    //     .collection('followers')
    //     .doc(authController.user.id)
    //     .get();

    if (!doc.exists) {
      // await firestore
      //     .collection('users')
      //     .doc(_uid.value)
      //     .collection('followers')
      //     .doc(authController.user.id)
      //     .set({});
      // await firestore
      //     .collection('users')
      //     .doc(authController.user.id)
      //     .collection('following')
      //     .doc(_uid.value)
      //     .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      // await firestore
      //     .collection('users')
      //     .doc(_uid.value)
      //     .collection('followers')
      //     .doc(authController.user.id)
      //     .delete();
      // await firestore
      //     .collection('users')
      //     .doc(authController.user.id)
      //     .collection('following')
      //     .doc(_uid.value)
      //     .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
