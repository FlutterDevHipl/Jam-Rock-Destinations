import 'dart:io';

import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/custom_widget.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  File? selectedImage;
  bool isPasswordVisible = false;
  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    // Crop Image
    final croppedPath = await CustomWidget().cropImage(image.path);
    if (croppedPath == null) return;

    // Compress Image
    final compressedFile =
        await CustomWidget().compressImage(File(croppedPath));

    setState(() {
      selectedImage = compressedFile;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [
              /// Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  CustomWidget().buildTextWidget(
                    title: "Profile Setup",
                    fontSize: 20,
                    textColor: AppColors.black500,
                    fontWeight: FontWeight.w700,
                  ),
                  const Spacer(),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffE8F5EA),
                    ),
                    child: Center(
                      child: CustomWidget().buildTextWidget(
                        title: "1/3",
                        fontSize: 14,
                        textColor: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget().buildTextWidget(
                  title: "Personal Details",
                  fontSize: 18,
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget().buildTextWidget(
                  title: "Fill in your details to get started.",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black400,
                ),
              ),

              const SizedBox(height: 35),

              /// Profile Image
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : null,
                    child: selectedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.green500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// Email
              Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget().buildTextWidget(
                  title: "Full Name",
                  fontSize: 14,
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w600,
                ),
              ),

              heightSpace8,

              CustomWidget().buildTextFormField(
                darkMode: true, radius: 8,
                controller: fullNameController,
                keyboardType: TextInputType.name,
                // hintText:  "Sam Rider",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: SvgPicture.asset(Images.emailIcon),
                ),
              ),

              heightSpace24,

              /// Password
              Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget().buildTextWidget(
                  title: "Email",
                  fontSize: 14,
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w600,
                ),
              ),

              heightSpace8,

              CustomWidget().buildTextFormField(
                darkMode: true, radius: 8,
                controller: fullNameController,
                keyboardType: TextInputType.name,
                // hintText: "sam.rider@gmail.com",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: SvgPicture.asset(
                    Images.emailIcon,
                    color: AppColors.black500,
                  ),
                ),
              ),

              heightSpace24,

              /// Phone
              Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget().buildTextWidget(
                  title: "Phone",
                  fontSize: 14,
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              heightSpace8,
              CustomWidget().buildTextFormField(
                darkMode: true, radius: 8,
                controller: phoneController,
                keyboardType: TextInputType.number,
                // hintText: "+1 876 555 1234",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: SvgPicture.asset(
                    Images.phoneIcon,
                    color: AppColors.black500,
                  ),
                ),
              ),

              heightSpace24,

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Save & Next
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: CustomWidget().buildTextWidget(
                    title: "Save & Next",
                    fontSize: 18,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
