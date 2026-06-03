import 'package:intl/intl.dart';

abstract class Formatters {
  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String rupees(double amount) => _inr.format(amount);

  static String rupeesLakhs(double lakhs) {
    if (lakhs >= 100) {
      final crore = lakhs / 100;
      return '₹${crore.toStringAsFixed(crore == crore.roundToDouble() ? 0 : 2)}Cr';
    }
    return '₹${lakhs % 1 == 0 ? lakhs.toInt() : lakhs}L';
  }

  static String percent(double value) => '${value.toStringAsFixed(0)}%';

  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  static String timeOfDay(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }

  static String countLabel(int count, String singular, String plural) {
    return '$count ${count == 1 ? singular : plural}';
  }
}
