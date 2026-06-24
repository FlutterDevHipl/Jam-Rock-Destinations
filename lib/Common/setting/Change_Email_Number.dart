import 'package:Jam_Rock_Destinations/Common/Controller/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../Utils/app_const.dart';


class ContactUpdateScreen extends StatefulWidget {
  final bool isEmail;
  final String value;

  const ContactUpdateScreen({
    super.key,
    required this.isEmail,
    required this.value,
  });

  @override
  State<ContactUpdateScreen> createState() => _ContactUpdateScreenState();
}

class _ContactUpdateScreenState extends State<ContactUpdateScreen> {
   TextEditingController controller=TextEditingController();
  ProfileController profileController=Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    // controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomWidget().buildTextWidget(title: "Contact Update",textColor: AppColors.black500,fontWeight: FontWeight.w700,fontSize: 20)
        // const Text(
        //   "Contact Update",
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 24,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              CustomWidget().buildTextWidget(title:     widget.isEmail
                  ? "Change Your Email"
                  : "Change Your Number",textColor: AppColors.black500,fontWeight: FontWeight.w700,fontSize: 24),
              // Text(
              //   widget.isEmail
              //       ? "Change Your Email"
              //       : "Change Your Number",
              //   style: const TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.w700,
              //     color: Color(0xFF2E3138),
              //   ),
              // ),

              const SizedBox(height: 8),
              CustomWidget().buildTextWidget(title:        widget.isEmail
                  ? "We'll verify your new email\nbefore updating."
                  : "We'll verify your new Number\nbefore updating.",textColor: AppColors.black500,fontWeight: FontWeight.w400,fontSize: 16,textAlign: TextAlign.center ),
              // Text(
              //   widget.isEmail
              //       ? "We'll verify your new email\nbefore updating."
              //       : "We'll verify your new Number\nbefore updating.",
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: Color(0xFF6B7280),
              //   ),
              // ),

              const SizedBox(height: 35),

              Align(
                alignment: Alignment.centerLeft,
                child:
                CustomWidget().buildTextWidget(title:   widget.isEmail ? "Email" : "Phone Number",textColor: AppColors.black500,fontWeight: FontWeight.w600,fontSize: 14)
                // Text(
                //   widget.isEmail ? "Email" : "Phone Number",
                //   style: const TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),

              ),

              const SizedBox(height: 8),
              widget.isEmail?
              CustomWidget().buildTextFormField(darkMode: false,controller: controller, keyboardType:

                   TextInputType.emailAddress,
              hintText:
                   "Enter Email"
                 ,
                prefixIcon: Icon(
                 Icons.email_outlined,
                  color: AppColors.black500,
                ),


                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }

                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );

                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Please enter a valid email address";
                    }

                    return null;
                  },
                filled: true,
                radius: 8
              ):
              CustomWidget().buildPhoneField(
                darkMode: profileController.isDarkMode?true:false,
                selectedCountry: profileController.selectedCountry,
                controller: controller,
                radius: 8,
                hintText: "Enter phone number",
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter phone number";
                  }

                  if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                    return "Phone number must be 10 digits";
                  }

                  return null;
                },
                color:  const Color(0xffF5F5F5),
                enableCountryPicker:userType != "EXPLORER"?false:true,
                onCountryChanged: (country) {
                  profileController.countryCode.value=country.phoneCode;
                  print(
                    "Selected Country: ${country.name} (+${country.phoneCode})",
                  );
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F8F46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    final value = controller.text.trim();

                    if (widget.isEmail) {
                      // profileController.ContactUpdate("email", value, context);
                      profileController.sendVerificationOTp(value, "email", context,"");
                      print("Email: $value");

                    } else {

                      profileController.sendVerificationOTp("+${profileController.countryCode.value+value}","phone",
                          context,profileController.countryCode.value.isEmpty?"1":profileController.countryCode.value);
                      print("Phone: $value");
                    }
                  },
                  child: Text(
                    widget.isEmail
                        ? "Verify Email"
                        : "Verify Number",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
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