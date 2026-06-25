import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BookRidecontroller extends GetxController {
  var isLoading = false.obs;
  TextEditingController pickupLocCont = TextEditingController();
  TextEditingController dropLocCont = TextEditingController();

  var isPickUp = true.obs;
  var isDrop = false.obs;

  var sheetOpened = false.obs;
  var buttonText = "".obs;

  var selectedIndex = 0.obs;
  var selectedValue = "<=4".obs;

  final List<String> items = ["<=4", "5", "6", "7", "8", "9"];

  void onPessengersSelect(int index, String value) {
    selectedIndex.value = index;
    selectedValue.value = value;
  }

  void openPessengersMoreMenu(BuildContext context, Offset offset) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 1,
        offset.dy + 1,
      ),
      items: List.generate(
        6,
        (i) => PopupMenuItem(
          value: "${9 + i}",
          child: Text("${9 + i}"),
        ),
      )..add(
          const PopupMenuItem(
            value: "15+",
            child: Text("15+"),
          ),
        ),
    );

    if (result != null) {
      selectedValue.value = result;
      selectedIndex.value = -1;
    }
  }
}
