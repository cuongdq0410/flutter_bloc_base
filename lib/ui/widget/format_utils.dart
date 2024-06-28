import 'package:intl/intl.dart';

class FormatUtils {
  static String formatyyyyMM(DateTime date) {
    final format = DateFormat('yyyy/MM');
    return format.format(date);
  }

  static String moneyFormat(num money) {
    return NumberFormat.decimalPattern().format(money);
  }

  static DateTime fromTimestampToDate(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static int fromDateToTimeStamp(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  static String formatyyyyMMdd(DateTime date) {
    final format = DateFormat('yyyy/MM/dd');
    return format.format(date);
  }

  static String formatyyyyMMddHHMM(DateTime date) {
    final format = DateFormat('yyyy/MM/dd HH:mm');
    return format.format(date);
  }

  static String formatMMddyy(DateTime date) {
    final format = DateFormat('MM/dd/yy');
    return format.format(date);
  }

  static String formatTimeStampToStringDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
