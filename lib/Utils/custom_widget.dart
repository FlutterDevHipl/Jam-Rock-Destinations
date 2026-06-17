import 'dart:ui';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'AppGradients.dart';
import 'app_colors.dart';
import 'app_images.dart';


enum ImageType { rectangle, circle, user }

class CustomWidget {
  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  // void openCustomDrawer() {
  //   Get.generalDialog(
  //     barrierLabel: "Drawer",
  //     barrierDismissible: true,
  //     barrierColor: Colors.black54,
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return Align(
  //         alignment: Alignment.centerLeft,
  //         child: Material(
  //           color: Colors.transparent,
  //           child: SizedBox(
  //             width: Get.width * 0.8,
  //             child: DrawerView(),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return SlideTransition(
  //         position: Tween(
  //           begin: const Offset(-1, 0),
  //           end: Offset.zero,
  //         ).animate(animation),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  showCustomToast(
      {required String message,
      Color backgroundColor = AppColors.redColor600}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: backgroundColor,
        fontSize: 16.0);
  }

  PreferredSizeWidget buildCustomAppBar({
    required BuildContext context,
    required String title,
    VoidCallback? onBack,
    List<Widget>? actions,
    String? imagePath,
  }) {
    return AppBar(
        backgroundColor: AppColors.appColor,
        titleSpacing: 16,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: Container(
          height: 63,
          margin: const EdgeInsets.only(left: 16, top: 5, bottom: 5),
          child: buildCustomBackButton(
            onTap: onBack ?? () => Navigator.pop(context),
          ),
        ),
        title: imagePath != null
            ? SvgPicture.asset(
                imagePath,
                height: 25,
              )
            : CustomWidget().buildTextWidget(
                title: title,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColors.whiteColor,
              ),
        actions: actions);
  }

  buildMaterialBtn({
    required String text,
    required Function() onPressed,
    double? height,
    double? minWidth,
    double? radius,
    double? fontSize,
    Color textColor = AppColors.whiteColor,
     Color? color,
    // Gradient? gradient,
  }) {
    return Container(
      height: height ?? 48,
      width: minWidth ?? Get.width,

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius ?? 30),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: height ?? 48,
        minWidth: minWidth ?? Get.width,
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        child: CustomWidget().buildTextWidget(
          title: text,
          fontSize: fontSize ?? 16,
          textColor: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  buildOutlinedBtn({
    required String text,
    required Function() onPressed,
    double? radius,
    double? fontSize,
    double? height,
    double? width,
    Color textColor = AppColors.whiteColor,
    Color pressedTextColor = AppColors.purpleColor700,
    Color hoverColor = AppColors.purpleColor700,
    Color btBorderColor = AppColors.borderColor,
  }) {
    bool _isPressed = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Listener(
          onPointerDown: (_) => setState(() => _isPressed = true),
          onPointerUp: (_) => setState(() => _isPressed = false),
          child: SizedBox(
            height: height ?? 48,
            width: width ?? Get.width,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: btBorderColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
              ).copyWith(
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return hoverColor;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return hoverColor;
                  }
                  return null;
                }),
              ),
              onPressed: onPressed,
              child: CustomWidget().buildTextWidget(
                title: text,
                fontSize: fontSize ?? 16,
                textColor: _isPressed ? pressedTextColor : textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget gradientDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.midnightNavy,
            AppColors.lavenderMist,
            AppColors.midnightNavy,
          ],
        ),
      ),
    );
  }

  Widget buildDivider(
      {double height = 1, Color? color, double horizontalPadding = 5}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      height: height,
      color: color ?? AppColors.borderColor.withOpacity(0.2),
    );
  }

  buildCircularProgress({
    double? height,
    double? width,
    double? radius,
    Color color = AppColors.appColor,
    Color backgroundColor = AppColors.purpleColor700,
    Gradient? gradient,
  }) {
    return Container(
      height: height ?? 48,
      width: width ?? Get.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient ?? AppGradients.pinkPurple,
        borderRadius: BorderRadius.circular(radius ?? 30),
      ),
      child: CircularProgressIndicator(
        color: AppColors.whiteColor,
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget buildCustomBackButton({
    VoidCallback? onTap,
    double size = 48,
    Color backgroundColor = AppColors.borderColor,
    Color borderColor = AppColors.borderColor,
    Color iconColor = AppColors.whiteColor,
    IconData? icon = CupertinoIcons.back,
    String? svgPath, // ✅ SVG support
    double iconSize = 20,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor.withOpacity(0.2),
          border: Border.all(color: borderColor.withOpacity(0.1)),
        ),
        child: Center(
          child: svgPath != null
              ? SvgPicture.asset(
                  svgPath,
                  height: iconSize,
                  width: iconSize,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              : Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
        ),
      ),
    );
  }

  buildTextWidget({
    required String title,
    double? fontSize,
    Color textColor = AppColors.purpleColor700,
    FontWeight fontWeight = FontWeight.w600,
    TextAlign textAlign = TextAlign.left,
    int? maxLines = 100,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return Text(
      title,
      style: GoogleFonts.inter(
          fontSize: fontSize ?? 16, color: textColor, fontWeight: fontWeight),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  buildTextFormField({
    TextEditingController? controller,
    String? Function(String?)? validator,
    String? labelText,
    String? hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    bool? readOnly,
    int? maxLength,
    TextStyle? labelStyle,
    Widget? prefixIcon,
    double? radius,
    Color color = Colors.white,
    Function()? onTap,
    Function(String s)? onChanged,
    TextInputType? keyboardType = TextInputType.text,
    required bool darkMode,
    bool enabled = true,
    bool filled = true,
    TextCapitalization textCapitalization = TextCapitalization.words,
    TextAlign textAlign = TextAlign.left,
    int maxLines = 1,
  }) {
    return TextFormField(
      textAlign: textAlign,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      maxLines: maxLines,
      inputFormatters: keyboardType == TextInputType.number
          ? [
              LengthLimitingTextInputFormatter(maxLength),
              FilteringTextInputFormatter.digitsOnly
            ]
          : [
              LengthLimitingTextInputFormatter(maxLength),
            ],
      enabled: enabled,
      readOnly: readOnly ?? false,
      style: GoogleFonts.inter(color:  AppColors.black500, fontSize: 15),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: const Color(0xffF5F5F5),


        filled: filled,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.w600,

        ),
        errorMaxLines: 2,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 15,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconConstraints: BoxConstraints(
          minWidth: 40,
          minHeight: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          borderSide: BorderSide(
              color: AppColors.black50, width: 1),
        ),
        hoverColor: Colors.red,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          borderSide: BorderSide(
              color: AppColors.black50, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          borderSide: BorderSide(
              color: AppColors.black50, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  Widget buildPhoneField({
    required bool darkMode,
    String? hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    required Rx<Country?> selectedCountry, // 👈 dynamic
    bool enabled = true,
    bool filled = false,
    Widget? suffixIcon,
    double? radius,
    bool readOnly = false,
    Color color = AppColors.blackColor,
    void Function(Country)? onCountryChanged,
    int? maxLength,
    Function()? onTap,
    bool enableCountryPicker = true, // 👈 new flag
  }) {
    final focusNode = FocusNode();

    return FormField<String>(
      initialValue: controller?.text, // ✅ important
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (state) {
        print("dark mode $darkMode");
        final hasError = state.hasError;
        final borderColor = hasError
            ? Colors.red
            : focusNode.hasFocus
                ? AppColors.borderColor.withOpacity(0.2)
                : AppColors.borderColor.withOpacity(0.2);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              focusNode: focusNode,
              onFocusChange: (_) => state.setState(() {}),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(radius ?? 30),
                  border: Border.all(color: borderColor, width: 1),
                ),

                child: Row(
                  children: [
                    GestureDetector(
                      onTap:enableCountryPicker
                          ?  () {
                        showCountryPicker(
                          context: Get.context!,
                          showPhoneCode: true,
                          useSafeArea: false,
                          // 👈 important
                          countryListTheme: CountryListThemeData(
                            bottomSheetHeight: Get.height * 0.65,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            inputDecoration: InputDecoration(
                              hintText: "Search country",
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            textStyle: GoogleFonts.lato(
                              fontSize: 14,
                              color:
                              Get.isDarkMode ? Colors.white : Colors.black
                            ),
                          ),
                          onSelect: (Country country) {
                            selectedCountry.value = country;
                            if (onCountryChanged != null) {
                              onCountryChanged(country);
                            }
                            state.setState(() {});
                          },
                        );
                      }: null,
                      child: Row(
                        children: [
                         SvgPicture.asset(Images.phoneIcon),
                          widthSpace8,
                          Text(
                            '+${selectedCountry.value?.phoneCode}',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: AppColors.green500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 1,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: AppColors.borderColor.withOpacity(0.2),
                    ),

                    /// PHONE FIELD
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        enabled: enabled,
                        readOnly: readOnly,
                        onTap: onTap,

                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          if (maxLength != null)
                            LengthLimitingTextInputFormatter(maxLength),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: GoogleFonts.inter(
                          color: AppColors.black500,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: suffixIcon,
                          hintText: hintText,
                          filled: filled,
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onChanged: (value) => state.didChange(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  state.errorText ?? '',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget buildExpandableText({
    required String text,
    int trimLength = 80,
  }) {
    final ValueNotifier<bool> isExpanded = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, expanded, _) {
        final bool shouldTrim = text.length > trimLength;

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: expanded || !shouldTrim
                    ? text
                    : text.substring(0, trimLength),
                style: const TextStyle(
                  color: AppColors.greyColor500,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (shouldTrim)
                TextSpan(
                  text: expanded ? "  Show less" : "  ...Show more",
                  style: const TextStyle(
                    color: AppColors.pinkColor400,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      isExpanded.value = !expanded;
                    },
                ),
            ],
          ),
        );
      },
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Translation("Your Email is required").tr();
    }
    final allowedTlds = [
      'com',
      'in',
      'org',
      'net',
      'co',
      'de',
      'uk',
      'fr',
      'us',
      'jp'
    ];
    final regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})$');
    final match = regex.firstMatch(value.trim());
    if (match == null || !allowedTlds.contains(match.group(2))) {
      return Translation("Enter a valid email").tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Translation("Password is required").tr();
    }

    if (value.length < 8) {
      return Translation('The password must be at least 8 characters.').tr();
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~^%()_+{}\[\]:;<>,.?\\/-]).{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return Translation(
              "Password must include uppercase, lowercase, number, and special character.")
          .tr();
    }

    return null;
  }

  String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required";
    }
    if (value != originalPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  String getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) return "";
    if (url.startsWith("http")) return url;
    return "https://$url";
  }

  Widget buildNoDataWidget({
  required BuildContext context,
  String? message,
  required String imagePath,
  double? height,
  double? width,
  double imageHeight = 100,
  TextStyle? textStyle,
  Widget? actionWidget,
}) {
  return Center(
    child: SizedBox(
      // height: height ?? MediaQuery.of(context).size.height * 0.5,
      width:width?? MediaQuery.of(context).size.height * 0.1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: imageHeight),
            const SizedBox(height: 10),
            Text(
              message ?? Translation('No data found').tr(),
              style: textStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            if (actionWidget != null) ...[
              const SizedBox(height: 15),
              actionWidget,
            ]
          ],
        ),
      ),
    ),
  );
}

  Widget customNetworkImage({
    required String? imageUrl,
    double borderRadius = 16,
    double width = 50,
    double height = 50,
    BoxFit fit = BoxFit.fitHeight,
    ImageType type = ImageType.rectangle,
  }) {
    final isValid = imageUrl != null && imageUrl.trim().isNotEmpty;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),

        border: Border.all(
          width: 1,
          color: AppColors.borderColor.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: isValid
            ? Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return _errorWidget(width, height, type);
                },
              )
            : _errorWidget(width, height, type),
      ),
    );
  }

  Widget _errorWidget(double width, double height, ImageType type) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: type == ImageType.user
            ? const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              )
            : Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: width == 50 || width == 60 ? 30 : 60,
              ),
      ),
    );
  }

  void showSuccessPopup({
    required String title,
    required String message,
    required Function() onPressed,
    String? buttonText,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // ✅ Dismiss the popup
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child:
                    Container(color: AppColors.midnightNavy.withOpacity(0.2)),
              ),
            ),
            Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: AppColors.borderColor.withOpacity(0.2),
                child: Builder(
                  builder: (context) {
                    return IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: AppColors.borderColor.withOpacity(0.2),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(Images.popupImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              heightSpace30,
                              Image.asset(
                                Images.successRight,
                                fit: BoxFit.cover,
                                height: 87,
                              ),
                              heightSpace35,
                              CustomWidget().buildTextWidget(
                                title: title,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.whiteColor,
                                textAlign: TextAlign.center,
                              ),
                              heightSpace10,
                              CustomWidget().buildTextWidget(
                                title: message,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.whiteColor,
                                textAlign: TextAlign.center,
                              ),
                              heightSpace30,
                              CustomWidget().buildOutlinedBtn(
                                text: buttonText ?? "Done",
                                btBorderColor:
                                    AppColors.borderColor.withOpacity(0.2),
                                onPressed: onPressed,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpgradePopup({
    required String title,
    required String message,
    required Function() onPressed,
    String? buttonText,
  }) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // ✅ Dismiss the popup
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child:
                    Container(color: AppColors.midnightNavy.withOpacity(0.2)),
              ),
            ),
            Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: AppColors.borderColor.withOpacity(0.2),
                child: Builder(
                  builder: (context) {
                    return IntrinsicHeight(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.blackColor.withOpacity(0.9),
                          border: Border.all(color: Colors.grey.shade900)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            heightSpace10,
                            CustomWidget().buildTextWidget(
                              title: title,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.whiteColor,
                              textAlign: TextAlign.center,
                            ),
                            heightSpace10,
                            CustomWidget().buildTextWidget(
                              title: message,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.greyColor500,
                              textAlign: TextAlign.center,
                            ),
                            heightSpace30,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomWidget().buildOutlinedBtn(
                                    text: buttonText ?? "Cancel",
                                    btBorderColor:
                                        AppColors.borderColor.withOpacity(0.2),
                                    onPressed: () {
                                      Get.back(); // ✅ Close the popup
                                    },
                                  ),
                                ),
                                widthSpace15,
                                Expanded(
                                  child: CustomWidget().buildMaterialBtn(
                                    text: buttonText ?? "Upgrade",
                                    // btBorderColor:
                                    //     AppColors.borderColor.withOpacity(0.2),
                                    onPressed: onPressed, color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatMinutes(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    if (remainingSeconds == 0) {
      return "$minutes"; // 4.0 → 4
    } else {
      double value = seconds / 60;
      return value.toStringAsFixed(1); // 4.5 → 4.5
    }
  }

  Widget chipTab(
    String text, {
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? null : AppColors.blackColor,
          gradient: isSelected ? AppGradients.pinkPurple : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.purpleColor400.withOpacity(0.9),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            CustomWidget().buildTextWidget(
              title: text,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget customNetWorkWidget() {
    return Container(
      alignment: Alignment.center,
      height: Get.height * 0.6,
      child: CustomWidget().buildTextWidget(
          title: Translation(
                  "Please check your internet connection or try again later.")
              .tr(),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          textColor: AppColors.purpleColor700,
          textAlign: TextAlign.center),
    );
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}

const widthSpace3 = SizedBox(width: 3);
const widthSpace5 = SizedBox(width: 5);
const widthSpace8 = SizedBox(width: 8);
const widthSpace10 = SizedBox(width: 10);
const widthSpace15 = SizedBox(width: 15);
const widthSpace20 = SizedBox(width: 20);
const widthSpace25 = SizedBox(width: 25);
const widthSpace30 = SizedBox(width: 30);
const widthSpace35 = SizedBox(width: 35);
const widthSpace40 = SizedBox(width: 40);
const widthSpace45 = SizedBox(width: 45);
const widthSpace50 = SizedBox(width: 50);

const heightSpace2 = SizedBox(height: 2);
const heightSpace16 = SizedBox(height: 16);
const heightSpace18 = SizedBox(height: 18);
const heightSpace5 = SizedBox(height: 5);
const heightSpace8 = SizedBox(height: 8);
const heightSpace12 = SizedBox(height: 12);
const heightSpace10 = SizedBox(height: 10);
const heightSpace15 = SizedBox(height: 15);
const heightSpace20 = SizedBox(height: 20);
const heightSpace24 = SizedBox(height: 24);
const heightSpace25 = SizedBox(height: 25);
const heightSpace30 = SizedBox(height: 30);
const heightSpace35 = SizedBox(height: 35);
const heightSpace40 = SizedBox(height: 40);
const heightSpace45 = SizedBox(height: 45);
const heightSpace48 = SizedBox(height: 48);
const heightSpace32 = SizedBox(height: 32);
const heightSpace50 = SizedBox(height: 50);
const heightSpace4 = SizedBox(height: 4);
