import 'dart:async';

import 'package:Jam_Rock_Destinations/Services/api_provider.dart';
import 'package:Jam_Rock_Destinations/Utils/api_url.dart';
import 'package:Jam_Rock_Destinations/Utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Services/GooglePlaceService.dart';

class DestinationController extends GetxController {
  var isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isLocationEntered = false.obs;
  final searchCont = TextEditingController();
  final stayLocationCont = TextEditingController();

  RxBool locationSheetShown = false.obs;
  RxList<dynamic> destinationData = <dynamic>[].obs;

  int currentPage = 1;
  int lastPage = 1;

  final ScrollController scrollController = ScrollController();
  RxList locations = [].obs;

  // Store filter values
  String search = "";
  double lat = 0.0;
  double lng = 0.0;
  int range = 5;

  final GooglePlacesService google =
      GooglePlacesService("AIzaSyD5Eq_GCROGxol5gkCgGlBWsxTCw3p3rM8");
  List<dynamic> places = [];
  Timer? timer;
  Map<String, dynamic>? selectedPlace;
  RxString searchText = "".obs;

  @override
  void onInit() {
    super.onInit();
    stayLocationCont.addListener(() {
      isLocationEntered.value = stayLocationCont.text.trim().isNotEmpty;
    });

    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    stayLocationCont.dispose();
    searchCont.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> getLatLng(String placeId) async {
    try {
      final detail = await google.getPlaceDetail(placeId);

      lat = detail["location"]["latitude"];
      lng = detail["location"]["longitude"];

      print("Latitude : $lat");
      print("Longitude: $lng");
    } catch (e) {
      print(e);
    }
  }

  void searchPlace(String value) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 400), () async {
      if (value.isEmpty) {
        places.clear();

        return;
      }
      final result = await google.searchPlaces(value);

      places = result;
    });
  }

  void initialize({
    required String search,
    required double lat,
    required double lng,
    required int range,
  }) {
    this.search = search;
    this.lat = lat;
    this.lng = lng;
    this.range = range;

    getDestination(
      search: search,
      lat: lat,
      lng: lng,
      range: range,
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isMoreLoading.value &&
        currentPage <= lastPage) {
      getDestination(
        search: search,
        lat: lat,
        lng: lng,
        range: range,
        loadMore: true,
      );
    }
  }

  Future<void> getDestination({
    required String search,
    required double lat,
    required double lng,
    required int range,
    bool loadMore = false,
  }) async {
    try {
      if (search.isEmpty) {
        locations.clear();
        return;
      }

      if (loadMore) {
        if (isMoreLoading.value || currentPage > lastPage) return;
        isMoreLoading.value = true;
      } else {
        isLoading.value = true;
        currentPage = 1;
      }

      final response = await ApiProvider().getRequest(
        apiUrl: "${AppConstants.getDestination}"
            "?page=$currentPage"
            "&search=$search"
            "&lat=$lat"
            "&long=$lng"
            "&range=$range",
        token: getToken(),
      );

      if (response["success"] == true) {
        final pageData = response["data"]["data"];

        currentPage = pageData["current_page"];
        lastPage = pageData["last_page"];

        List<dynamic> list = pageData["data"];

        if (loadMore) {
          destinationData.addAll(list);
        } else {
          destinationData.assignAll(list);
        }

        currentPage++;
      } else {
        ApiProvider().showErrorFromResponse(response);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
}
