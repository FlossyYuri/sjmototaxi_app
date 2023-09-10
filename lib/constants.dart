import 'package:flutter/material.dart';
import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/VeicleModel.dart';

const kPrimaryColor = Color.fromARGB(255, 244, 95, 55);
const kPrimaryLightColor = Color.fromARGB(255, 255, 255, 255);
const List<String> places = [
  'KFC Guerra Popular, Baia Mall',
  'Teka Famba',
  'Baixa da Cidade'
];
const GOOGLE_API_KEY = 'AIzaSyB758DbueNvVzVrDktfLIGWGF7FNFMh2BU';

List<VeicleModel> veicleModels = [
  VeicleModel(
    VeicleTypes.bike,
    'assets/icons/single-motorbike.svg',
    30,
    0.7,
    'Motorizada',
  ),
  VeicleModel(
    VeicleTypes.txopela,
    'assets/icons/txopela.svg',
    40,
    0.8,
    'Txopela',
  ),
  VeicleModel(
    VeicleTypes.car,
    'assets/icons/car-black-side-silhouette.svg',
    50,
    1,
    'Carro',
  ),
];
