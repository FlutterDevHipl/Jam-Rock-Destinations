import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Common/ProfileController/ProfileController.dart';
import 'Change_Email_Number.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.getFAQ();
      controller.getUserProfile();
    });
  }

  int expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    controller.name.text = controller.getProfileData["name"]?.toString() ?? "";
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
              title: "Profile",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black500)),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      heightSpace20,

                      /// Profile Image
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.green.shade100,
                                child: Obx(
                                  () => ClipOval(
                                    child:
                                        controller.selectedImage.value != null
                                            ? Image.file(
                                                controller.selectedImage.value!,
                                                width: 113,
                                                height: 113,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                controller.getProfileData[
                                                            "profile_image_url"]
                                                        ?.toString() ??
                                                    "",
                                                width: 113,
                                                height: 113,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                  width: 113,
                                                  height: 113,
                                                  color: AppColors.offWhite,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: AppColors.green500,
                                                    size: 60,
                                                  ),
                                                ),
                                              ),
                                  ),
                                )),
                          ),
                          Positioned(
                            child: GestureDetector(
                              onTap: () {
                                controller.showImagePickerOptions(context);
                              },
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.50),
                                      blurRadius: 3,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// Full Name
                      _title("Full Name"),
                      heightSpace8,
                      Obx(
                        () => CustomWidget().buildTextFormField(
                            darkMode: false,
                            controller: controller.name,
                            initialValue: controller.getProfileData["name"],
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(14),
                              child: SvgPicture.asset(
                                Images.outlinePerson,
                                color: AppColors.black500,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != controller.getProfileData["name"]) {
                                controller.hasChanges.value = true;
                                print(
                                    "Has changes ${controller.hasChanges.value}");
                              }

                              print("value => $value");
                              print("controller => ${controller.name.text}");
                              print("Api ${controller.getProfileData["name"]}");
                            },
                            radius: 8),
                      ),
                      // _customField(
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset(Images.personOutlineIcon),
                      //       SizedBox(width: 10),
                      //       CustomWidget().buildTextWidget(
                      //         title:
                      //         controller
                      //             .getProfileData["name"]
                      //             .toString(),
                      //         fontSize: 16,
                      //         textColor: AppColors.black500,
                      //         fontWeight: FontWeight.w400,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 20),

                      /// Email
                      _title("Email"),
                      const SizedBox(height: 8),
                      _customField(
                        child: Row(
                          children: [
                            SvgPicture.asset(Images.emailOutlineIcon),
                            const SizedBox(width: 10),
                            Expanded(
                              child:

                              CustomWidget().buildTextWidget(
                                title: controller.getProfileData["email"]
                                    .toString(),
                                fontSize: 16,
                                textColor: AppColors.black500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            updateButton(
                              () {
                                if(controller.getProfileData["login_type"]=="normal")
                                  {
                                    Get.to(ContactUpdateScreen(
                                        isEmail: true,
                                        value: controller.getProfileData["email"]));
                                  }

                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Phone
                      _title("Phone"),
                      const SizedBox(height: 8),
                      _customField(
                        child: Row(
                          children: [
                            SvgPicture.asset(Images.contactOutlineIcon),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomWidget().buildTextWidget(
                                title:controller.getProfileData["country_code"] +" "+controller.getProfileData["phone"].toString(),
                                fontSize: 16,
                                textColor: AppColors.black500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            updateButton(
                              () {
                                Get.to(ContactUpdateScreen(
                                    isEmail: false,
                                    value: controller.getProfileData["phone"]));
                              },
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),
// CustomWidget().buildMaterialBtn(
//   color: controller.hasChanges.value ? controller.selectedImage.value!=null? AppColors.green500 : Colors.grey,
//   radius: 8,
//   height: 50,minWidth: double.maxFinite,
//   textColor: Colors.white,
//   text: "Save", onPressed: () {
//
//   if(controller.hasChanges.value || controller.selectedImage.value!=null )
//   {
//     controller.editProfile();
//   }
// },),
                      CustomWidget().buildMaterialBtn(
                        color: (controller.hasChanges.value ||
                                controller.selectedImage.value != null)
                            ? AppColors.green500
                            : Colors.grey,
                        radius: 8,
                        height: 50,
                        minWidth: double.maxFinite,
                        textColor: Colors.white,
                        text: "Save",
                        onPressed: () {
                          print(controller.selectedImage.value);
                          if (controller.hasChanges.value ||
                              controller.selectedImage.value != null) {
                            controller.editProfile();
                          }
                        },
                      ),
                      // Obx(() {
                      //
                      //
                      //   return SizedBox(
                      //     width: double.maxFinite,
                      //     child: ElevatedButton(
                      //
                      //       onPressed: () {
                      //         if(controller.hasChanges.value)
                      //           {
                      //             controller.editProfile();
                      //           }
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor:
                      //         controller.hasChanges.value ? AppColors.green500 : Colors.grey,
                      //       ),
                      //
                      //       child: CustomWidget().buildTextWidget(title: "Save",textColor: controller.hasChanges.value ?Colors.white:Colors.grey,),
                      //     ),
                      //   );
                      // }),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  static Widget _title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomWidget().buildTextWidget(
        title: text,
        fontSize: 14,
        textColor: AppColors.black500,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget _customField({required Widget child}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        border: Border.all(
          color: AppColors.black50,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  static Widget updateButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomWidget().buildTextWidget(
          title: "Update",
          fontSize: 14,
          textColor: AppColors.green500,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
