import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthStoreController extends GetxController {
  final box = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxMap<String, dynamic> auth = {"user": {}, "token": null}.obs;
  var isLoading = false.obs;

  void login(payload) {
    auth = {"user": payload['user'], "token": payload['token']}.obs;
    _persistData();
  }

  void logout() {
    auth = {"user": {}, "token": null}.obs;
    box.erase();
    Get.offAllNamed('/auth/login');
    _auth.signOut();
  }

  void updateLoader(bool payload) {
    print(payload.toString());
    isLoading = payload.obs;
    isLoading.refresh();
  }

  void _persistData() {
    box.write('auth', auth);
  }

  void initAuthStore() {
    var storedData = box.read('auth');
    if (storedData != null) {
      auth = (storedData as Map<String, dynamic>).obs;
    }
  }
}
