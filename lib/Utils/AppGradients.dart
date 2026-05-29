import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  static const Alignment _begin = Alignment.bottomRight;
  static const Alignment _end = Alignment.topLeft;

  static const LinearGradient pinkPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA125EB),
      AppColors.hotPink,
    ],
  );
  
  // 1
  static const LinearGradient limeGold = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.limeGreen,
      AppColors.goldenYellow,
    ],
  );

  // 2
  static const LinearGradient Purplepink = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.hotPink,
      Color(0xFFA125EB),

    ],
  );
  static const LinearGradient purpleBlue = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.mediumOrchid,
      AppColors.royalBlue,
    ],
  );

  // 3
  static const LinearGradient yellowGreen = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.canaryYellow,
      AppColors.emeraldGreen,
    ],
  );

  // 4
  static const LinearGradient goldOrange = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.sandyYellow,
      AppColors.burntOrange,
    ],
  );

  // 5
  static const LinearGradient pinkLavender = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.hotPink,
      AppColors.lavenderPurple,
    ],
  );

  // 6
  static const LinearGradient brownGold = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.darkBrown,
      AppColors.lightGold,
    ],
  );

  // 7
  static const LinearGradient neonRed = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.neonYellow,
      AppColors.crimsonRed,
    ],
  );

  // 8
  static const LinearGradient salmonChestnut = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.lightSalmon,
      AppColors.chestnutBrown,
    ],
  );

  // 9
  static const LinearGradient aquaGreen = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.turquoise,
      AppColors.forestGreen,
    ],
  );

  // 10
  static const LinearGradient purpleOrange = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [
      AppColors.mediumPurple,
      AppColors.pumpkinOrange,
    ],
  );
}
