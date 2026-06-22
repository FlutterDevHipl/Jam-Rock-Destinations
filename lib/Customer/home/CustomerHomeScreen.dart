import 'package:Jam_Rock_Destinations/Common/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/HomeController.dart';
import 'package:Jam_Rock_Destinations/Customer/home/DestinationScreen.dart';
import 'package:Jam_Rock_Destinations/Customer/notification/NotificationScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  HomeController controller = Get.put(HomeController());
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
              : Column(
                  children: [
                    _buildHeader(),
                    const Divider(height: 1),
                    heightSpace20,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget().buildTextFormField(
                                darkMode: false,
                                hintText: "Where to go?",
                                prefixIcon: Icon(Icons.search)),
                            heightSpace20,
                            const RecentLocationTile(),
                            heightSpace10,
                            const Divider(
                              color: AppColors.black50,
                            ),
                            heightSpace10,
                            const RecentLocationTile(),
                            heightSpace20,
                            CustomWidget().buildTextWidget(
                              title: "Book Your Ride",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.black500,
                            ),
                            heightSpace20,
                            StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 0.7,
                                  child: RideCard(
                                    title: "Affordable & Quick",
                                    subtitle: "Taxi",
                                    image: "assets/images/taxi.png",
                                  ),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 0.9,
                                  child: RideCard(
                                    title: "Pre Book &",
                                    subtitle: "Ride Stress-Free",
                                    image: "assets/images/prebook.png",
                                  ),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 0.9,
                                  child: RideCard(
                                    title: "Enjoy Ride with",
                                    subtitle: "Car Comfort",
                                    image: "assets/images/car.png",
                                  ),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 0.7,
                                  child: RideCard(
                                    title: "See All",
                                    subtitle: "Services",
                                    image: "assets/images/services.png",
                                  ),
                                ),
                              ],
                            ),
                            heightSpace25,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomWidget().buildTextWidget(
                                  title: "Popular Destinations",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  textColor: AppColors.black500,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(DestinationScreen());
                                  },
                                  child: CustomWidget().buildTextWidget(
                                    title: "See All",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            heightSpace15,
                            SizedBox(
                              height: 190,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  return const DestinationCard();
                                },
                              ),
                            ),
                            heightSpace20
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Image.asset(
            Images.logoIcon,
            width: 47,
            height: 45,
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(NotificationScreen());
            },
            child: Stack(
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
          ),
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            child: profileController.getProfileData["profile_image_url"] == null
                ? CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(Images.personLogo))
                : ClipOval(
                    child: Image.network(
                      profileController.getProfileData["profile_image_url"]
                          .toString(),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ],
      ),
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

class RideCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const RideCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12, top: 12),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title\n",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black400,
                    ),
                  ),
                  TextSpan(
                    text: subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black500,
                    ),
                  ),
                  TextSpan(
                    text: " Ride",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          heightSpace5,
          Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                Images.logoIcon,
                width: 70,
                height: 40,
              )),
        ],
      ),
    );
  }
}

class RecentLocationTile extends StatelessWidget {
  const RecentLocationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: const Icon(
            Icons.access_time,
            color: AppColors.black300,
          ),
        ),
        widthSpace10,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomWidget().buildTextWidget(
              title: "Dunn's River Falls",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppColors.black500,
            ),
            CustomWidget().buildTextWidget(
              title: "Ocho Rios, Jamaica",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.black300,
            ),
          ],
        ),
        CustomWidget().buildTextWidget(
          title: "12km away",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          textColor: AppColors.black300,
        ),
      ],
    );
  }
}
