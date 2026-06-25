
import 'package:get/get.dart';

class DriverHomeController extends GetxController {
  var isLoading = false.obs;
  var isOnline = false.obs;
  final List<Map<String, String>> rideList = [
    {
      "title": "Affordable & Quick",
      "subtitle": "Taxi",
      "image": "assets/images/taxi.png",
    },
    {
      "title": "Pre Book &",
      "subtitle": "Ride Stress-Free",
      "image": "assets/images/prebook.png",
    },
    {
      "title": "Enjoy Ride with",
      "subtitle": "Car Comfort",
      "image": "assets/images/car.png",
    },
    {
      "title": "See All",
      "subtitle": "Services",
      "image": "assets/images/services.png",
    },
  ];
}
