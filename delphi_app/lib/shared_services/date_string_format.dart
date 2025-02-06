import 'package:intl/intl.dart';

class DateStringFormat {
  static String formatEndDate(int endDate) {
    // Extract the first 12 characters and ignore the last 6 digits
    String formattedDate = endDate.toString().substring(0, 8);

    // Convert to DateTime object
    DateTime dateTime = DateTime.parse(formattedDate);

    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
