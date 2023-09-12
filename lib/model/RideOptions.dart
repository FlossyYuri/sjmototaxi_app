import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/Driver.dart';
import 'package:agotaxi/model/place.dart';

class RideOptions {
  GoogleMapsPlace? origin;
  GoogleMapsPlace? destiny;
  VeicleTypes? type;
  int? price;
  int? discount;
  int? distance; // in kilometers
  String? formatedDistance; // in kilometers
  int? duration; // in minutes
  String? formatedDuration; // in minutes
  Driver? driver;

  RideOptions(
      this.origin,
      this.destiny,
      this.type,
      this.discount,
      this.distance,
      this.driver,
      this.duration,
      this.formatedDistance,
      this.formatedDuration,
      this.price);

  void treatDistance(
    int? dist,
    String? fDistance,
    int? dur,
    String? fDuration,
  ) {
    distance = dist;
    formatedDistance = fDistance;
    duration = dur;
    formatedDuration = fDuration;
  }

  @override
  String toString() {
    return 'Origem:${origin != null ? origin!.name : ""}, Destino:${destiny != null ? destiny!.name : ""}, Distance:$formatedDistance, Duration:$formatedDuration, Type:${type != null ? type : ""}, Preço:${price != null ? price : ""}, ';
  }
}
