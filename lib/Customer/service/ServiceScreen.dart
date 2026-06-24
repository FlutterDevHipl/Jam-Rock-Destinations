import 'package:Jam_Rock_Destinations/Common/Controller/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/ServiceController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  Servicecontroller controller = Get.put(Servicecontroller());
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      /// Header
                      _buildHeader(),
                      const Divider(height: 1),

                      const SizedBox(height: 20),

                      /// Services Grid
                      Expanded(
                        child: GridView.builder(
                          itemCount: controller.services.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.98,
                          ),
                          itemBuilder: (context, index) {
                            final item = controller.services[index];

                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: Get.width,
                                  height: Get.height,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.black50,
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          Images.carImage,
                                        ),
                                        fit: BoxFit.contain,
                                      )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomWidget().buildTextWidget(
                                        title: item["title"],
                                        fontSize: 14,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.black400,
                                      ),
                                      const Spacer(),
                                      // Center(
                                      //   child: Image.asset(
                                      //     item["image"],
                                      //     height: 65,
                                      //     fit: BoxFit.contain,
                                      //   ),
                                      // ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          CustomWidget().buildTextWidget(
                                            title: item["users"].toString(),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            textColor: AppColors.black400,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SvgPicture.asset(
                                  Images.car,
                                  height: 65,
                                  width: 65,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomWidget().buildTextWidget(
              title: "Services",
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black500,
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications_outlined, size: 25),
              Positioned(
                // right: 10,
                bottom: 8,
                // top: 4,
                child: Container(
                  // height: 8,
                  // width: 8,
                  padding: EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: CustomWidget().buildTextWidget(
                      title: "2",
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.whiteColor,
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Visibility(
            visible: userType == "EXPLORER" ? true : false,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  profileController.getProfileData["profile_image_url"]
                      .toString(),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
