import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpmobile/const/colors.dart';

class AppTextStyle {
  static TextStyle headerText = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );
  static TextStyle descText = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );
  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryTextColor,
  );
  static TextStyle infoText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.infoTextColor,
  );
  static TextStyle titleText = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryTextColor,
  );
  static TextStyle subtitleText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.subtitleColor,
  );
  static TextStyle cardInfoText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.cardInfoColor,
  );
 
}
