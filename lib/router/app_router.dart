import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers/auth_providers.dart';
import '../features/splash_auth/screens/splash_screen.dart';
import '../features/splash_auth/screens/pin_entry_screen.dart';
import '../features/splash_auth/screens/recovery_entry_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/onboarding/screens/setup_pin_screen.dart';
import '../features/onboarding/screens/setup_recovery_screen.dart';
import '../features/onboarding/screens/setup_biometric_screen.dart';
import '../features/onboarding/screens/setup_backup_screen.dart';
import '../features/onboarding/screens/setup_complete_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/passwords/screens/passwords_list_screen.dart';
import '../features/passwords/screens/add_edit_password_screen.dart';
import '../features/passwords/screens/password_detail_screen.dart';
import '../features/documents/screens/documents_list_screen.dart';
import '../features/documents/screens/add_document_screen.dart';
import '../features/documents/screens/document_detail_screen.dart';
import '../features/notes/screens/notes_list_screen.dart';
import '../features/notes/screens/add_edit_note_screen.dart';
import '../features/notes/screens/note_detail_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/settings/screens/security_settings_screen.dart';
import '../features/settings/screens/backup_settings_screen.dart';
import '../features/settings/screens/change_pin_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const setupPin = '/setup-pin';
  static const setupRecovery = '/setup-recovery';
  static const setupBiometric = '/setup-biometric';
  static const setupBackup = '/setup-backup';
  static const setupComplete = '/setup-complete';
  static const pinEntry = '/pin-entry';
  static const recoveryEntry = '/recovery-entry';
  static const home = '/home';
  static const passwords = '/passwords';
  static const addPassword = '/passwords/add';
  static const editPassword = '/passwords/edit';
  static const passwordDetail = '/passwords/detail';
  static const documents = '/documents';
  static const addDocument = '/documents/add';
  static const documentDetail = '/documents/detail';
  static const notes = '/notes';
  static const addNote = '/notes/add';
  static const editNote = '/notes/edit';
  static const noteDetail = '/notes/detail';
  static const settings = '/settings';
  static const securitySettings = '/settings/security';
  static const backupSettings = '/settings/backup';
  static const changePin = '/settings/change-pin';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final status = authState.status;

      // Debug logging
      debugPrint('Redirect: Current path: $path, AuthStatus: $status');

      final isOnboarding =
          path.startsWith('/welcome') || path.startsWith('/setup-');
      final isAuth = path == AppRoutes.pinEntry ||
          path == AppRoutes.recoveryEntry ||
          path == AppRoutes.splash;

      switch (status) {
        case AuthStatus.unknown:
          return AppRoutes.splash;
        case AuthStatus.unauthenticated:
          if (!isOnboarding) return AppRoutes.welcome;
          return null;
        case AuthStatus.locked:
          if (!isAuth) return AppRoutes.pinEntry;
          return null;
        case AuthStatus.authenticated:
          if (isAuth || isOnboarding) return AppRoutes.home;
          return null;
      }
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: AppRoutes.welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(
          path: AppRoutes.setupPin, builder: (_, __) => const SetupPinScreen()),
      GoRoute(
        path: AppRoutes.setupRecovery,
        builder: (_, state) =>
            SetupRecoveryScreen(recoveryPhrase: state.extra as String),
      ),
      GoRoute(
          path: AppRoutes.setupBiometric,
          builder: (_, __) => const SetupBiometricScreen()),
      GoRoute(
          path: AppRoutes.setupBackup,
          builder: (_, __) => const SetupBackupScreen()),
      GoRoute(
          path: AppRoutes.setupComplete,
          builder: (_, __) => const SetupCompleteScreen()),
      GoRoute(
          path: AppRoutes.pinEntry, builder: (_, __) => const PinEntryScreen()),
      GoRoute(
          path: AppRoutes.recoveryEntry,
          builder: (_, __) => const RecoveryEntryScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(
          path: AppRoutes.passwords,
          builder: (_, __) => const PasswordsListScreen()),
      GoRoute(
        path: AppRoutes.addPassword,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return AddEditPasswordScreen(
            existingId: args?['id'],
            existingData: args?['data'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.passwordDetail,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return PasswordDetailScreen(id: args['id'], data: args['data']);
        },
      ),
      GoRoute(
          path: AppRoutes.documents,
          builder: (_, __) => const DocumentsListScreen()),
      GoRoute(
        path: AppRoutes.addDocument,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return AddDocumentScreen(
              existingId: args?['id'],
              existingData: args?['data'],
              documentType: args?['type']);
        },
      ),
      GoRoute(
        path: AppRoutes.documentDetail,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return DocumentDetailScreen(
              id: args['id'], documentType: args['type'], data: args['data']);
        },
      ),
      GoRoute(
          path: AppRoutes.notes, builder: (_, __) => const NotesListScreen()),
      GoRoute(
        path: AppRoutes.addNote,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return AddEditNoteScreen(
              existingId: args?['id'], existingData: args?['data']);
        },
      ),
      GoRoute(
        path: AppRoutes.noteDetail,
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return NoteDetailScreen(id: args['id'], data: args['data']);
        },
      ),
      GoRoute(
          path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
      GoRoute(
          path: AppRoutes.securitySettings,
          builder: (_, __) => const SecuritySettingsScreen()),
      GoRoute(
          path: AppRoutes.backupSettings,
          builder: (_, __) => const BackupSettingsScreen()),
      GoRoute(
          path: AppRoutes.changePin,
          builder: (_, __) => const ChangePinScreen()),
    ],
  );
});
