import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility functions for formatting and converting data
class AppUtils {
  /// Format price with currency symbol
  static String formatPrice(
    double price, {
    String currency = '€',
    int decimals = 2,
  }) {
    return '$currency${price.toStringAsFixed(decimals)}';
  }

  /// Format date to readable format
  static String formatDate(DateTime date, {bool includeYear = true}) {
    final formatter = includeYear
        ? DateFormat('dd.MM.yyyy')
        : DateFormat('dd.MM');
    return formatter.format(date);
  }

  /// Format time to readable format
  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format duration in minutes to readable format
  static String formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}min';
  }

  /// Calculate tax from price
  static double calculateTax(double price, {double taxRate = 0.19}) {
    return price * taxRate;
  }

  /// Calculate gross price from net
  static double calculateGross(double netPrice, {double taxRate = 0.19}) {
    return netPrice + (netPrice * taxRate);
  }

  /// Generate unique booking reference ID
  static String generateBookingReferenceId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7);
    final random = List.generate(3, (_) => (0 + 9).toString()).join();
    return 'BK$timestamp$random'.toUpperCase();
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Format file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)}MB';
  }

  /// Truncate text with ellipsis
  static String truncateText(
    String text,
    int maxLength, {
    String ellipsis = '...',
  }) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$ellipsis';
  }

  /// Convert DateTime to ISO string
  static String dateTimeToIso(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Convert ISO string to DateTime
  static DateTime? isoToDateTime(String iso) {
    try {
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }

  /// Get initials from name
  static String getInitials(String name) {
    return name
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join()
        .substring(0, 2)
        .padRight(2, ' ');
  }

  /// Format phone number
  static String formatPhoneNumber(String phone) {
    // Remove all non-digits
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) return phone;
    if (digits.length <= 3) return digits;
    if (digits.length <= 6) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    }
    if (digits.length <= 10) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }

    return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 9)} ${digits.substring(9)}';
  }
}
