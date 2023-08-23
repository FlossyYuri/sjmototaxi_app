import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sjmototaxi_app/enums/RideTypes.dart';
import 'package:sjmototaxi_app/model/Driver.dart';
import 'package:sjmototaxi_app/model/place.dart';

class RideOptions {
  GoogleMapsPlace? origin;
  GoogleMapsPlace? destiny;
  VeicleTypes? type;
  int? price;
  int? discount;
  int? distance; // in kilometers
  int? estimatedTime; // in minutes
  Driver? driver;

  RideOptions(this.origin, this.destiny, this.type, this.discount,
      this.distance, this.driver, this.estimatedTime, this.price);
}
