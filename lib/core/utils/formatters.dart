import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, {String currency = 'NGN'}) {
    try {
      final formatter = NumberFormat.currency(
        symbol: _symbol(currency),
        decimalDigits: 2,
      );
      return formatter.format(amount);
    } catch (_) {
      return '$currency ${amount.toStringAsFixed(2)}';
    }
  }

  static String _symbol(String currency) {
    const map = {
      'NGN': '₦',
      'USD': '\$',
      'GBP': '£',
      'EUR': '€',
      'GHS': 'GH₵',
      'KES': 'KSh',
      'ZAR': 'R',
    };
    return map[currency.toUpperCase()] ?? currency;
  }

  static String formatAmount(num amount, String? currency) =>
      format(amount.toDouble(), currency: currency ?? 'NGN');
}

class DateFormatter {
  DateFormatter._();

  static String format(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  static String formatWithTime(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (_) {
      return dateString;
    }
  }
}
