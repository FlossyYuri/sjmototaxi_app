import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/Driver.dart';
import 'package:agotaxi/model/place.dart';
import 'package:agotaxi/model/user.dart';
import 'package:agotaxi/utils/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideOptions {
  String? id;
  GoogleMapsPlace? origin;
  GoogleMapsPlace? destin;
  VeicleTypes? type;
  int? price;
  int? discount;
  int? distance;
  String? formatedDistance;
  int? duration;
  String? formatedDuration;
  UserModel? client;
  Driver? driver;
  String status = 'opened';
  List<String>? rejectedDrivers = [];
  DateTime? createdAt;
  DateTime? closedAt;

  RideOptions(
    this.origin,
    this.destin,
    this.type,
    this.discount,
    this.distance,
    this.driver,
    this.duration,
    this.formatedDistance,
    this.formatedDuration,
    this.price,
    this.status,
  );

  RideOptions.fromMap(Map<String, dynamic> ride) {
    id = ride['id'];
    origin = GoogleMapsPlace.fromMap(ride['origin']);
    destin = GoogleMapsPlace.fromMap(ride['destin']);
    type = stringToEnum(ride['type']);
    price = ride['price'];
    discount = ride['discount'];
    distance = ride['distance'];
    formatedDistance = ride['formatedDistance'];
    duration = ride['duration'];
    formatedDuration = ride['formatedDuration'];
    client = UserModel.fromMap(ride['client']);
    driver = ride['driver'] == null ? null : Driver.fromMap(ride['driver']);
    status = ride['status'] ?? 'opened';
    rejectedDrivers = ride['rejectedDrivers'] != null
        ? listDynamicToListString(ride['rejectedDrivers'])
        : [];
    createdAt = ride['createdAt'] != null
        ? (ride['createdAt'] as Timestamp).toDate()
        : null;
    closedAt = ride['closedAt'] != null
        ? (ride['closedAt'] as Timestamp).toDate()
        : null;
  }

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

  Map<String, dynamic> toMap() {
    return {
      "origin": origin!.toMap(),
      "destin": destin!.toMap(),
      "type": type.toString(),
      "discount": discount,
      "distance": distance,
      "status": status,
      "client": client?.toMap(),
      "driver": driver?.toMap(),
      "duration": duration,
      "formatedDistance": formatedDistance,
      "formatedDuration": formatedDuration,
      "price": price,
      "createdAt":
          createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
      "closedAt":
          closedAt != null ? Timestamp.fromDate(closedAt!) : Timestamp.now(),
    };
  }

  @override
  String toString() {
    return 'Origem:${origin != null ? origin!.name : ""}, Destino:${destin != null ? destin!.name : ""}, type: ${type.toString()}, price: ${price.toString()}, status: ${status.toString()}, Distance:$formatedDistance, Duration:$formatedDuration, Preço:${price != null ? price : ""}, ';
  }
}
