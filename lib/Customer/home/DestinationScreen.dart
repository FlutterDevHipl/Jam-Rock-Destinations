import 'package:Jam_Rock_Destinations/Customer/booking/BookingCancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/BookingController.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/HomeController.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/CancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DestinationScreen extends StatefulWidget {
  DestinationScreen({
    super.key,
  });

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: CustomWidget().buildTextWidget(
            title: "Destinations",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 20),
        actions: [
          IconButton(
            onPressed: () {
              showFilterBottomSheet(context);
            },
            icon: const Icon(
              Icons.tune,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : ListView(
                  padding: EdgeInsets.all(20),
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // heightSpace20,
                    CustomWidget().buildTextFormField(
                        darkMode: false,
                        hintText: "Search destinations",
                        prefixIcon: Icon(Icons.search)),

                    heightSpace20, 
                    // _emptyState(),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        return const DestinationCard();
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

  static Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.empty,
            width: 150,
            height: 150,
          ),
          heightSpace10,
          CustomWidget().buildTextWidget(
              title: " No results found",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              fontSize: 24),
          heightSpace10,
          CustomWidget().buildTextWidget(
              title: "We couldn't find anything matching Hanamachi",
              textColor: AppColors.black400,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
              fontSize: 16),
        ],
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    double distance = 150;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidget().buildTextWidget(
                        title: "Filter",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black500,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.green500,
                        ),
                      ),
                    ],
                  ),

                  heightSpace20,
                  CustomWidget().buildTextWidget(
                    title: "Select Distance",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.black500,
                  ),
                  heightSpace15,
                  CustomWidget().buildTextWidget(
                    title: "${distance.toInt()}km",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.fourthColor,
                  ),

                  Slider(
                    value: distance,
                    min: 0,
                    max: 400,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        distance = value;
                      });
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidget().buildTextWidget(
                        title: "0km",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.green500,
                      ),
                      CustomWidget().buildTextWidget(
                        title: "400km",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.green500,
                      ),
                    ],
                  ),

                  heightSpace25,

                  SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomWidget().buildOutlinedBtn(
                          text: "Reset",
                          btBorderColor: AppColors.green500,
                          fontSize: 16,
                          radius: 8,
                          textColor: AppColors.green500,
                          onPressed: () {
                            setState(() {
                              distance = 0;
                            });
                          },
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: CustomWidget().buildMaterialBtn(
                          text: "Reset",
                          color: AppColors.green500,
                          fontSize: 16,
                          radius: 8,
                          textColor: AppColors.whiteColor,
                          onPressed: () {
                            setState(() {
                              distance = 0;
                            });
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: AppColors.black50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Image.network(
                  fit: BoxFit.cover,
                  height: 115,
                  "https://as2.ftcdn.net/v2/jpg/20/51/66/11/1000_F_2051661191_GmUqdFaL2iex0PwyvGk0UgE8cp0NA0Wp.jpg")),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget().buildTextWidget(
                  title: "Dunn's River Falls",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black500,
                ),
                const SizedBox(height: 4),
                CustomWidget().buildTextWidget(
                  title: "Ocho Rios, Jamaica",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
