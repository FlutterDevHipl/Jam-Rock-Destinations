import 'package:Jam_Rock_Destinations/Customer/controller/DestinationController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Utils/app_images.dart';

class LocationBottomSheet extends StatelessWidget {
  LocationBottomSheet({super.key});
  final DestinationController controller = Get.find<DestinationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            heightSpace20,
            SizedBox(
              width: 230,
              height: 150,
              child: Image.asset(
                Images.destinationImagePNG,
                height: 120,
              ),
            ),
            heightSpace20,
            CustomWidget().buildTextWidget(
                title: "Looks like you're not in Jamaica!",
                textColor: AppColors.black500,
                fontWeight: FontWeight.w700,
                fontSize: 18),
            heightSpace10,
            CustomWidget().buildTextWidget(
                title:
                    "No worries — enter where you'll be staying and we'll show nearby destinations.",
                textColor: AppColors.black400,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                fontSize: 14),
            heightSpace30,
            CustomWidget().buildTextFormField(
              onChanged: (s) {
                controller.searchText.value = s;
                controller.searchPlace(s);
              },
              controller: controller.stayLocationCont,
              darkMode: false,
              hintText: "Enter your stay location",
              prefixIcon: Icon(Icons.search),
              suffixIcon: Obx(() {
                if (!controller.isLocationEntered.value) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    controller.stayLocationCont.clear();

                    controller.searchText.value = "";

                    controller.places.clear();

                    controller.selectedPlace = null;

                    controller.lat = 0.0;
                    controller.lng = 0.0;

                    controller.isLocationEntered.value = false;
                  },
                );
              }),
            ),
            heightSpace10,
            Obx(() {
              if (controller.searchText.value.isEmpty) {
                return const SizedBox();
              }

              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      color: AppColors.green500,
                    ),
                  ),
                );
              }

              if (controller.places.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomWidget().buildTextWidget(
                      title: "No Location Found.",
                      textColor: const Color.fromARGB(255, 70, 85, 109),
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      fontSize: 14),
                );
              }

              return Container(
                constraints: const BoxConstraints(maxHeight: 220),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(color: Colors.grey.shade300),
                //   borderRadius: BorderRadius.circular(8),
                // ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.places.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: AppColors.black50,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.places[index]["placePrediction"];

                    return ListTile(
                      dense: true,
                      title: CustomWidget().buildTextWidget(
                          title: item["text"]["text"] ?? "",
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                          fontSize: 14),
                      subtitle: CustomWidget().buildTextWidget(
                          title: item["structuredFormat"]?["secondaryText"]
                                  ?["text"] ??
                              "",
                          textColor: AppColors.black300,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.start,
                          fontSize: 12),
                      onTap: () async {
                        final selectedText = item["text"]["text"] ?? "";
                        controller.stayLocationCont.text = selectedText;
                        controller.selectedPlace = item;
                        print(
                            "Selected Stay Data: ${controller.selectedPlace}");
                        controller.searchText.value = "";
                        controller.places.clear();
                        controller.isLocationEntered.value = true;
                        await controller.getLatLng(item["placeId"]);

                        print("Lattitude: ${controller.lat}");
                        print("Longitude:${controller.lng}");
                        controller.getDestination(
                            search: controller.stayLocationCont.text,
                            lat: controller.lat,
                            lng: controller.lng,
                            range: 5);
                      },
                    );
                  },
                ),
              );
            }),
            heightSpace30,
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Obx(
                  () => CustomWidget().buildMaterialBtn(
                    color: controller.isLocationEntered.value
                        ? AppColors.green500
                        : AppColors.black100,
                    radius: 8,
                    height: 50,
                    minWidth: double.maxFinite,
                    textColor: Colors.white,
                    text: "Find Nearby Attractions",
                    onPressed: () {
                      if (controller.isLocationEntered.value) {}
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
