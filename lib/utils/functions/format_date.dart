import 'package:intl/intl.dart';

String formatDate(DateTime date, int switchValue) {
  switch (switchValue) {
    case 0:
      return DateFormat('MM-dd-yyyy').format(date);
    case 1:
      return DateFormat('dd-MM-yyyy').format(date);
    case 2:
      return DateFormat('yyyy-MM-dd').format(date);
    default:
      return DateFormat('MM-dd-yyyy').format(date);
  }
}
