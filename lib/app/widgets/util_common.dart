import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UtilCommon {
  static void snackBar({required String text, bool isFail = false}) {
    Get.snackbar('Note', text,
        colorText: Colors.white,
        backgroundColor: isFail ? Colors.red : Colors.green);
  }

  static String convertDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String convertDateTimeYMD(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String convertEEEDateTime(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy', 'vi_VN').format(date);
  }

  static DateTime combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static String formatMoney(double amount) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }
  static BoxDecoration shadowBox(BuildContext context,{
    double radiusBorder = 10,
    Color colorBg = Colors.white,
    Color colorSd = Colors.grey
  })=> BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorBg,
              boxShadow:  [
                BoxShadow(
                  color: colorSd,
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            );
}
