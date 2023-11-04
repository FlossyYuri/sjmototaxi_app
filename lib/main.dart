import 'package:agotaxi/firebase_options.dart';
import 'package:agotaxi/screens/Auth/login_screen.dart';
import 'package:agotaxi/screens/Client/cart_screen.dart';
import 'package:agotaxi/screens/Client/checkout/delivery_screen.dart';
import 'package:agotaxi/screens/Client/rate_screen.dart';
import 'package:agotaxi/screens/Client/checkout/rates_screen.dart';
import 'package:agotaxi/screens/Common/chat_screen.dart';
import 'package:agotaxi/screens/OnBoarding/onboarding_screen.dart';
import 'package:agotaxi/screens/client_ride_screen.dart';
import 'package:agotaxi/screens/driver_screen.dart';
import 'package:agotaxi/screens/home_page.dart';
import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AgoTaxiApp());
}

class AgoTaxiApp extends StatelessWidget {
  AgoTaxiApp({super.key});

  final AuthStoreController authStoreController =
      Get.put(AuthStoreController());
  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    authStoreController.initAuthStore();

    return GetMaterialApp(
      title: 'Ago Taxi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: HexColor("#FEA611"),
        secondaryHeaderColor: HexColor("#50555C"),
        canvasColor: HexColor("#F2F2F2"),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade500,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
          ),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      initialRoute: _auth.currentUser != null ? '/home' : '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/auth/login': (context) => const LoginScreen(),
        '/home': (context) => FutureBuilder(
            future: mapsStoreController.initRide(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Obx(() =>
                  authStoreController.auth['user']['role'] == 'DRIVER'
                      ? const DriverScreen()
                      : const ClientRideScreen());
            }),
        '/chat': (context) => const ChatScreen(),
        '/home2': (context) => const MyHomePage(),
        '/cart': (context) => const CartScreen(),
        '/delivery': (context) => const DeliveryScreen(),
        '/rate': (context) => const RateScreen(),
        '/rates': (context) => const RatesScreen(),
        '/extra': (context) => const MyHomePage(),
      },
    );
  }
}
