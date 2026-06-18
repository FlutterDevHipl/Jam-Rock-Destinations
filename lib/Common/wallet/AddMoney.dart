import 'package:Jam_Rock_Destinations/Common/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../Utils/app_images.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  ProfileController controller = Get.put(ProfileController());
  final TextEditingController _amountController = TextEditingController();
  String? _selectedPreset;

  final List<String> presets = ['100', '500', '1000'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectPreset(String amount) {
    setState(() {
      _selectedPreset = amount;
      _amountController.text = amount;
    });
  }

  bool get _isButtonEnabled {
    if (_amountController.text.isEmpty) return false;
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount >= 50;
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountController.text) ?? 0;

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
              title: "Add Money",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              fontSize: 20)),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  children: [
                    heightSpace20,
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: CustomWidget().buildTextWidget(
                          title:
                              "Wallet money can only be used to pay for rides on jam Rock Desitination",
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          fontSize: 16),
                    ),

                    heightSpace40,
                    // Balance / Amount Display
                    Center(
                      child: CustomWidget().buildTextWidget(
                          title: '\$${amount.toInt()}',
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          fontSize: 28),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        color: AppColors.black50,
                      ),
                    ),
                    heightSpace30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: presets.map((amt) {
                        final isSelected = _selectedPreset == amt;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectPreset(amt);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: AppColors.offWhite,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(color: AppColors.black50)),
                            child: CustomWidget().buildTextWidget(
                                title: '\$$amt',
                                textColor: AppColors.black500,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                                fontSize: 16),
                          ),
                        );

                        // ChoiceChip(
                        //   label: CustomWidget().buildTextWidget(
                        //       title: '\$$amt',
                        //       textColor: AppColors.black500,
                        //       fontWeight: FontWeight.w400,
                        //       textAlign: TextAlign.center,
                        //       fontSize: 16),
                        //   selected: isSelected,
                        //   onSelected: (_) => _selectPreset(amt),
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 12),
                        //   backgroundColor: Colors.grey[200],
                        //   selectedColor: Colors.green,
                        // );
                      }).toList(),
                    ),

                    heightSpace40,

                    Center(
                      child: CustomWidget().buildTextWidget(
                          title: 'Minimum recharge amount is \$50',
                          textColor: AppColors.black400,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          fontSize: 14),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Submit Logic
                            // CustomWidget().showSuccessPopup(
                            //     title: "Payment Successful!",
                            //     message:
                            //         "\$1500 has been added to your wallet! Enjoy Ride!",
                            //     onPressed: () {},
                            //     buttonText: "Okay");

                            CustomWidget().showSuccessPopup(
                                title: "Insufficient Balance",
                                message:
                                    "You don't have enough balance to complete this payment."
                                    "\nAdd money to your wallet to continue.",
                                onPressed: () {},
                                buttonText: "Add Money",
                                isError: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: amount.toInt() == 0
                                ? AppColors.black100
                                : AppColors.green500,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: CustomWidget().buildTextWidget(
                              title: "Confirm Amount",
                              textColor: AppColors.whiteColor,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                              fontSize: 16),
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
