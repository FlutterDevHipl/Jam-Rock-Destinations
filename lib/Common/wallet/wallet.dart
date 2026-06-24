import 'package:Jam_Rock_Destinations/Common/Controller/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Common/wallet/AddMoney.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../Utils/app_images.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.getFAQ();
    });
  }

  int expandedIndex = 0;

  final List<TransactionModel> transactions = [
    TransactionModel(
      title: "Ride Bonus",
      date: "10:11 AM, 23 May 2026",
      amount: "+\$10",
      isCredit: true,
      icon: Images.tabler_gift_filled,
      // iconColor: Colors.orange,
    ),
    TransactionModel(
      title: "Ride Payment",
      date: "10:11 AM, 23 May 2026",
      amount: "-\$100",
      isCredit: false,
      icon: Images.tabler_ride_filled,
    ),
    TransactionModel(
      title: "Added via Stripe",
      date: "10:11 AM, 23 May 2026",
      amount: "+\$1000",
      isCredit: true,
      icon: Images.tabler_payment_filled,
      // iconColor: Colors.green,
    ),
    TransactionModel(
      title: "Ride Payment",
      date: "10:11 AM, 23 May 2026",
      amount: "-\$100",
      isCredit: false,
      icon: Images.tabler_ride_filled,
    ),
    TransactionModel(
      title: "Ride Bonus",
      date: "10:11 AM, 23 May 2026",
      amount: "+\$10",
      isCredit: true,
      icon: Images.tabler_gift_filled,
      // iconColor: Colors.orange,
    ),
  ];

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
        title: const Text(
          "Wallet",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  children: [
                    heightSpace10,

                    /// Balance Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 155,
                        // padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.green50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                                right: -30,
                                bottom: -50,
                                child: Container(
                                  width: 180,
                                  height: 160,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(Images.walletBg))),
                                )),
                            Padding(
                              padding: EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomWidget().buildTextWidget(
                                            title: "Your Balance",
                                            textColor: AppColors.black400,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        heightSpace5,
                                        CustomWidget().buildTextWidget(
                                            title: "\$12,000",
                                            textColor: AppColors.black500,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24),
                                        const Spacer(),
                                        OutlinedButton(
                                          onPressed: () {
                                            Get.to(AddMoneyScreen());
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.green500,
                                            side: const BorderSide(
                                              color: AppColors.green500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: CustomWidget().buildTextWidget(
                                              title: "Add Money +",
                                              textColor: AppColors.green500,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),

                                  widthSpace20,

                                  /// Wallet Icon

                                  Image.asset(
                                    Images.walletImage,
                                    height: Get.height * .10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Transactions Heading
                    Visibility(
                      visible: transactions.length == 0 ? false : true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomWidget().buildTextWidget(
                              title: "Transactions",
                              textColor: AppColors.black500,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: transactions.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Images.emptyImage,
                                  width: 200,
                                  height: 160,
                                ),
                                heightSpace10,
                                CustomWidget().buildTextWidget(
                                    title:
                                        "No Transacation History Foundctions",
                                    textColor: AppColors.black500,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                                heightSpace10,
                                CustomWidget().buildTextWidget(
                                    title:
                                        "You haven't made any transaction yet.",
                                    textColor: AppColors.black400,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ],
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: transactions.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final item = transactions[index];

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SvgPicture.asset(item.icon),
                                  title: CustomWidget().buildTextWidget(
                                      title: item.title,
                                      textColor: AppColors.black500,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: CustomWidget().buildTextWidget(
                                        title: item.date,
                                        textColor: AppColors.black300,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                  trailing: CustomWidget().buildTextWidget(
                                      title: item.amount,
                                      textColor: item.isCredit
                                          ? AppColors.green500
                                          : AppColors.redColor400,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class TransactionModel {
  final String title;
  final String date;
  final String amount;
  final bool isCredit;
  final String icon;
  final Color? iconColor;

  TransactionModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.icon,
    this.iconColor,
  });
}
