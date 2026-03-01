import 'constants.dart';

class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? masterPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < SecurityConstants.minPasswordLength) {
      return 'Password must be at least ${SecurityConstants.minPasswordLength} characters';
    }
    if (value.length > SecurityConstants.maxPasswordLength) {
      return 'Password is too long';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'PIN is required';
    if (value.length < SecurityConstants.minPINLength) {
      return 'PIN must be at least ${SecurityConstants.minPINLength} digits';
    }
    if (value.length > SecurityConstants.maxPINLength) {
      return 'PIN must be at most ${SecurityConstants.maxPINLength} digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'PIN must be numeric';
    return null;
  }

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? cardNumber(String? value) {
    if (value == null || value.isEmpty) return 'Card number is required';
    final digits = value.replaceAll(' ', '');
    if (digits.length < 13 || digits.length > 19) return 'Enter a valid card number';
    if (!RegExp(r'^\d+$').hasMatch(digits)) return 'Card number must contain only digits';
    return null;
  }

  static String? cvv(String? value) {
    if (value == null || value.isEmpty) return 'CVV is required';
    if (value.length < 3 || value.length > 4) return 'CVV must be 3-4 digits';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'CVV must be numeric';
    return null;
  }

  static String? cardPin(String? value) {
    if (value == null || value.isEmpty) return null; // Optional
    if (value.length < 4 || value.length > 6) return 'Card PIN must be 4-6 digits';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Card PIN must be numeric';
    return null;
  }

  static String? expiryMonth(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final month = int.tryParse(value);
    if (month == null || month < 1 || month > 12) return 'Invalid month';
    return null;
  }

  static String? expiryYear(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final year = int.tryParse(value);
    if (year == null) return 'Invalid year';
    final currentYear = DateTime.now().year;
    if (year < currentYear || year > currentYear + 20) return 'Invalid year';
    return null;
  }

  static String? aadhaarNumber(String? value) {
    if (value == null || value.isEmpty) return 'Aadhaar number is required';
    final digits = value.replaceAll(' ', '');
    if (digits.length != 12) return 'Aadhaar number must be 12 digits';
    if (!RegExp(r'^\d+$').hasMatch(digits)) return 'Invalid Aadhaar number';
    return null;
  }

  static String? panNumber(String? value) {
    if (value == null || value.isEmpty) return 'PAN number is required';
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    if (!panRegex.hasMatch(value.toUpperCase())) return 'Invalid PAN format (e.g. ABCDE1234F)';
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return 'URL is required';
    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme) return 'Enter a valid URL (include https://)';
    } catch (_) {
      return 'Enter a valid URL';
    }
    return null;
  }

  /// Returns password strength 0-4 (0=very weak, 4=very strong)
  static int passwordStrength(String password) {
    if (password.length < 6) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\|;:,.<>\?]').hasMatch(password)) score++;
    return score.clamp(0, 4);
  }
}
