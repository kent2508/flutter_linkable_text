import 'package:intl/intl.dart';

import '../flutter_string_utils.dart';

extension FLTStringExtensions on String {
  String get removeDiacritics {
    return StringUtils.removeDiacritics(this);
  }

  String get toDateStringWithFormatDDMMYYYY {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final date = DateTime.tryParse(this);
    if (date != null) {
      return dateFormat.format(date);
    } else {
      return 'wrong-date-format';
    }
  }
}
