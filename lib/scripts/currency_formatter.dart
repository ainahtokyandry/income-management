import 'package:intl/intl.dart';

String currencyFormatter(String currency, double arg) {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return NumberFormat.currency(
          name: currency, decimalDigits: 2, customPattern: '#,###.# \u00a4')
      .format(arg)
      .replaceAll(',', ' ')
      .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}
