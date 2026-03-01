import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  // PIN verification
  late String pinHash;  // Argon2id hash of PIN (for verification)
  late String pinSalt;  // Salt for PIN hash

  // KEK wrapped by PIN-derived key (primary vault access)
  late String wrappedKEK;  // KEK encrypted with PIN-derived key
  late String kekIV;        // IV for wrappedKEK decryption

  // KEK wrapped by recovery phrase-derived key (fallback)
  late String wrappedKEKByRecovery;  // KEK encrypted with recovery-derived key
  late String recoveryKekIV;          // IV for recovery KEK
  late String recoveryPhraseHash;     // Hash of recovery phrase (for verification)

  // Settings
  late bool biometricEnabled;
  late bool autoBackupEnabled;
  late String autoBackupFrequency;

  DateTime? lastBackupDate;
  late DateTime createdAt;
  late DateTime updatedAt;
}
