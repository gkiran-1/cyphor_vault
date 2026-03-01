import 'dart:math';

class PasswordGenerator {
  PasswordGenerator._();

  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _numbers = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generate({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    final random = Random.secure();
    final pool = StringBuffer();
    final required = <String>[];

    if (includeUppercase) {
      pool.write(_uppercase);
      required.add(_uppercase[random.nextInt(_uppercase.length)]);
    }
    if (includeLowercase) {
      pool.write(_lowercase);
      required.add(_lowercase[random.nextInt(_lowercase.length)]);
    }
    if (includeNumbers) {
      pool.write(_numbers);
      required.add(_numbers[random.nextInt(_numbers.length)]);
    }
    if (includeSymbols) {
      pool.write(_symbols);
      required.add(_symbols[random.nextInt(_symbols.length)]);
    }

    if (pool.isEmpty) {
      pool.write(_lowercase);
      required.add(_lowercase[random.nextInt(_lowercase.length)]);
    }

    final poolStr = pool.toString();
    final chars = List<String>.from(required);

    while (chars.length < length) {
      chars.add(poolStr[random.nextInt(poolStr.length)]);
    }

    // Fisher-Yates shuffle
    for (int i = chars.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = chars[i];
      chars[i] = chars[j];
      chars[j] = temp;
    }

    return chars.take(length).join();
  }
}
