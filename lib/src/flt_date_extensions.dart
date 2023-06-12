import 'package:intl/intl.dart';

extension FLTDateTimeExtensions on DateTime {
  String get toDateStringWithFormatDDMMYYYY {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(this);
  }
}
