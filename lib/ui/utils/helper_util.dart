import 'package:intl/intl.dart';

class HelperUtil {
  static String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '$hours h, ';
    }

    if (minutes > 0 || hours > 0) {
      formattedTime += '$minutes m, ';
    }

    formattedTime += '$remainingSeconds s';

    return formattedTime;
  }

  static formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('yyyy/MM/dd - hh:mm a');
    return formatter.format(date).toLowerCase();
  }
}
