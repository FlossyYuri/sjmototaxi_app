import 'package:agotaxi/enums/RideTypes.dart';

class VeicleModel {
  VeicleTypes type;
  String icon;
  double pricePerKM;
  double speed;
  String name;

  VeicleModel(this.type, this.icon, this.pricePerKM, this.speed, this.name);
}
