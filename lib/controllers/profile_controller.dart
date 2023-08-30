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

    var followerDoc = profileData.followers;
    var followingDoc = profileData.following;

    followers = followerDoc!.length;
    following = followingDoc!.length;

    if (followerDoc.contains(authController.user.id)) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': profileData.username,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    final profile =
        await supabase.from('profiles').select().eq('id', _uid.value).single();
    final profileId = profile['id'];

    final currentUser = await supabase
        .from('profiles')
        .select()
        .eq('id', authController.user.id)
        .single();
    final currentUserId = currentUser['id'];

    var followerDoc = profile['followers'] ?? [];
    var followers = [];
    followerDoc.forEach((element) {
      followers.add(element);
    });

    if (followerDoc.contains(currentUserId)) {
      followers.remove(currentUserId);
      try {
        await supabase
            .from('profiles')
            .update({'followers': followers}).eq('id', profileId);
      } catch (e) {
        Get.snackbar(
          'Error updating followers',
          e.toString(),
        );
      }
    } else {
      followers.add(currentUserId);
      try {
        // This design of followers breaks RLS TODO: Fix this
        await supabase
            .from('profiles')
            .update({'followers': followers}).match({'id': profileId});
      } catch (e) {
        Get.snackbar(
          'Error updating followers',
          e.toString(),
        );
      }
    }

    _user.value.update(
      'followers',
      (value) => followers.length.toString(),
    );

    var followingDoc = currentUser['following'] ?? [];
    var following = [];
    followingDoc.forEach((element) {
      following.add(element);
    });
    if (followingDoc.contains(_uid.value)) {
      following.remove(_uid.value);
      try {
        await supabase
            .from('profiles')
            .update({'following': following}).eq('id', currentUserId);
        _user.value.update('isFollowing', (value) => false);
      } on Exception catch (e) {
        Get.snackbar(
          'Error updating following',
          e.toString(),
        );
      }
    } else {
      following.add(_uid.value);
      try {
        await supabase
            .from('profiles')
            .update({'following': following}).eq('id', currentUserId);
        _user.value.update('isFollowing', (value) => true);
      } on Exception catch (e) {
        Get.snackbar(
          'Error updating following',
          e.toString(),
        );
      }
    }

    _user.value.update(
      'following',
      (value) => following.length.toString(),
    );
    update();
  }
}
