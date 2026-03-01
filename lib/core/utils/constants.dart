class SecurityConstants {
  SecurityConstants._();

  // Argon2id parameters
  static const int argon2Iterations = 3;
  static const int argon2MemoryKB = 65536; // 64 MB
  static const int argon2Parallelism = 4;
  static const int argon2KeyLength = 64; // 512 bits

  // AES-256-GCM
  static const int aesKeyLength = 32; // 256 bits
  static const int gcmIVLength = 12; // 96 bits
  static const int gcmTagLength = 16; // 128 bits

  // PIN
  static const int minPINLength = 4;
  static const int maxPINLength = 6;
  static const int maxPINAttempts = 3;

    // Password
    static const int minPasswordLength = 8;
    static const int maxPasswordLength = 128;

  // Session
  static const Duration revealDuration = Duration(seconds: 5);
  static const Duration clipboardClearDelay = Duration(seconds: 30);

  // Backup
  static const int maxGoogleDriveBackups = 5;
  static const String backupFileExtension = '.cipherbox';
  static const String backupFolderName = 'CipherBox Backups';

  // Image
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int imageCompressionQuality = 80;

  // Storage keys for Flutter Secure Storage
  static const String kekKey = 'cipherbox_kek';
  static const String pinSaltKey = 'cipherbox_pin_salt';
  static const String recoverySaltKey = 'cipherbox_recovery_salt';
}

class AppConstants {
  AppConstants._();

  static const String appName = 'CipherBox';
  static const String dbName = 'cipherbox';

  // Backup frequency options
  static const String backupDaily = 'daily';
  static const String backupWeekly = 'weekly';
  static const String backupOnChange = 'on_change';

  // Document types
  static const String docAadhaar = 'aadhaar';
  static const String docPAN = 'pan';
  static const String docDebitCard = 'debit_card';
  static const String docCreditCard = 'credit_card';

  // Note categories
  static const String noteImportantLink = 'important_link';
  static const String noteGeneral = 'note';

  // Card networks
  static const String cardVisa = 'visa';
  static const String cardMastercard = 'mastercard';
  static const String cardRupay = 'rupay';
  static const String cardAmex = 'amex';
  static const String cardOther = 'other';
}
