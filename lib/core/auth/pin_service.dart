import '../database/isar_service.dart';
import '../encryption/key_manager.dart';

class PINService {
  PINService._();
  static final PINService instance = PINService._();

  int _failedAttempts = 0;
  static const int maxAttempts = 3;

  int get failedAttempts => _failedAttempts;
  bool get isLocked => _failedAttempts >= maxAttempts;

  Future<bool> verifyPIN(String pin) async {
    if (isLocked) return false;

    try {
      await KeyManager.instance.unlockWithPIN(pin);
      _failedAttempts = 0;
      return true;
    } catch (_) {
      _failedAttempts++;
      return false;
    }
  }

  void resetFailedAttempts() {
    _failedAttempts = 0;
  }

  Future<bool> hasPIN() async {
    final profile = await IsarService.instance.getUserProfile();
    return profile != null && profile.pinHash.isNotEmpty;
  }

  Future<void> updatePIN(String newPIN) async {
    await KeyManager.instance.changePIN(newPIN);
    resetFailedAttempts();
  }
}
