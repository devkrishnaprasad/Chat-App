import 'package:intl/intl.dart';

class AppWrapper {
  String formatTimestamp(int timestamp) {
    // Convert milliseconds timestamp to DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format DateTime object to desired format
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
}
