import 'package:intl/intl.dart';

import 'language/localization.dart';

class CustomDateUtils {
  static String getStringFromDate(DateTime? dateTime) {
    if (dateTime == null) {
      return intl.invalidDate;
    } else {
      return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
    }
  }

  static DateTime? getDateFromString(String stringDate) {
    try {
      return DateFormat('dd/MM/yyyy - HH:mm').parse(stringDate);
    } catch (e) {
      return null;
    }
  }

  static String getStringFromDateWithSeconds(DateTime? dateTime) {
    if (dateTime == null) {
      return intl.invalidDate;
    } else {
      return DateFormat('dd/MM/yyyy - HH:mm:ss').format(dateTime);
    }
  }

  static String getStringFromDateForFilename(DateTime? dateTime) {
    if (dateTime == null) {
      return intl.invalidDate;
    } else {
      return DateFormat('dd_MM_yyyy_HH_mm').format(dateTime);
    }
  }

  static String? getStringFromDateForJson(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }

    return null;
  }
}
