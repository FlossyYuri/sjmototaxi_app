import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthStoreController extends GetxController {
  final box = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxMap<String, dynamic> auth = {"user": {}, "token": null}.obs;
  var isLoading = false.obs;

  String userRole() {
    return auth.value['user']['role'];
  }

  void login(payload) {
    auth = {"user": payload['user'], "token": payload['token']}.obs;
    _persistData();
  }

  void logout() async {
    final MapsStoreController mapsStoreController =
        Get.find<MapsStoreController>();
    auth = {"user": {}, "token": null}.obs;
    mapsStoreController.resetMaps();
    await box.erase();
    await _auth.signOut();
    Get.offAllNamed('/auth/login');
  }

  void updateLoader(bool payload) {
    isLoading.value = payload;
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
