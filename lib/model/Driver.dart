import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/user.dart';
import 'package:agotaxi/utils/index.dart';

class Driver extends UserModel {
  VeicleTypes veicleType = VeicleTypes.car;
  String brand = '';
  String plate = '';

  Driver(this.brand, this.plate, this.veicleType, String name, String role,
      String email, String phone, String photo, String uid)
      : super(name, role, uid, email, phone, photo);

  Driver.fromMap(Map<String, dynamic> user) : super.fromMap(user) {
    brand = user['brand'];
    plate = user['plate'];
    veicleType = stringToEnum(user['veicleType']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'uid': uid,
      'email': email,
      'phone': phone,
      'photo': photo,
      'brand': brand,
      'plate': plate,
      'veicleType': veicleType.toString(),
    };
  }
}
