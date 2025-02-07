import 'package:get/get.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/models/user_profile.dart';

class UserSearchController extends GetxController {
  final Rx<List<ProfileUser>> _users = Rx<List<ProfileUser>>([]);
  List<ProfileUser> get users => _users.value;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  searchUser(String? typedUser) async {
    try {
      final search = await supabase
          .from('profiles')
          .select()
          .ilike('username', '%$typedUser%');

      _users.value = [];
      for (int i = 0; i < search.length; i++) {
        _users.value.add(ProfileUser.fromMap(map: search[i]));
      }
    } catch (e) {
      Get.snackbar(
        'Error getting users',
        e.toString(),
      );
    }
  }
}
