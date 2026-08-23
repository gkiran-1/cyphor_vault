import 'package:flutter/material.dart';
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
import '../features/pages/screens/pages_list_screen.dart';
import '../features/pages/screens/page_editor_screen.dart';
import '../features/pages/screens/page_view_screen.dart';

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
  static const pages = '/pages';
  static const addPage = '/pages/add';
  static const editPage = '/pages/edit';
  static const pageDetail = '/pages/detail';
}

// Fade transition for root-level screens only (splash, home, auth).
// These intentionally do NOT support swipe-back / system back gesture.
CustomTransitionPage<void> _noPopFadePage(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

// Notifier that bridges Riverpod's authStateProvider to GoRouter's
// refreshListenable, so auth changes trigger redirect re-evaluation
// WITHOUT recreating the GoRouter (which would destroy the nav stack).
final _authNotifierProvider = Provider<AuthChangeNotifier>((ref) {
  final notifier = AuthChangeNotifier();
  ref.listen<AuthState>(authStateProvider, (_, __) => notifier.notify());
  ref.onDispose(notifier.dispose);
  return notifier;
});

class AuthChangeNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(_authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final status = ref.read(authStateProvider).status;

      // Debug logging
      debugPrint('Redirect: Current path: $path, AuthStatus: $status');

      final isOnboarding =
          path.startsWith('/welcome') || path.startsWith('/setup-');
      final isAuthScreen =
          path == AppRoutes.pinEntry || path == AppRoutes.recoveryEntry;

      switch (status) {
        case AuthStatus.unknown:
          return AppRoutes.splash;
        case AuthStatus.unauthenticated:
          if (!isOnboarding) return AppRoutes.welcome;
          return null;
        case AuthStatus.locked:
          // Splash must also redirect here — it is not a valid resting
          // place once the notifier has resolved to locked.
          if (!isAuthScreen) return AppRoutes.pinEntry;
          return null;
        case AuthStatus.authenticated:
          // Only redirect auth screens (splash, pin-entry, recovery-entry)
          // to home. Do NOT redirect onboarding screens — the onboarding
          // flow sets status to authenticated during setup (createAccount)
          // and manages its own navigation to recovery → biometric → home.
          if (path == AppRoutes.splash || isAuthScreen) return AppRoutes.home;
          return null;
      }
    },
    routes: [
      // Root / auth routes — fade transition
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (_, state) => _noPopFadePage(state.pageKey, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (_, state) => _noPopFadePage(state.pageKey, const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.pinEntry,
        pageBuilder: (_, state) => _noPopFadePage(state.pageKey, const PinEntryScreen()),
      ),
      GoRoute(
        path: AppRoutes.recoveryEntry,
        pageBuilder: (_, state) =>
            _noPopFadePage(state.pageKey, const RecoveryEntryScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (_, state) => _noPopFadePage(state.pageKey, const HomeScreen()),
      ),

      // Onboarding — platform default transition
      GoRoute(
        path: AppRoutes.setupPin,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const SetupPinScreen()),
      ),
      GoRoute(
        path: AppRoutes.setupRecovery,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: SetupRecoveryScreen(recoveryPhrase: state.extra as String),
        ),
      ),
      GoRoute(
        path: AppRoutes.setupBiometric,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const SetupBiometricScreen()),
      ),
      GoRoute(
        path: AppRoutes.setupBackup,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const SetupBackupScreen()),
      ),
      GoRoute(
        path: AppRoutes.setupComplete,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const SetupCompleteScreen()),
      ),

      // List screens — platform default transition (supports back gesture)
      GoRoute(
        path: AppRoutes.passwords,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const PasswordsListScreen()),
      ),
      GoRoute(
        path: AppRoutes.documents,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const DocumentsListScreen()),
      ),
      GoRoute(
        path: AppRoutes.notes,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const NotesListScreen()),
      ),
      GoRoute(
        path: AppRoutes.pages,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const PagesListScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const SettingsScreen()),
      ),

      // Detail / add / edit routes — platform default (supports back gesture)
      GoRoute(
        path: AppRoutes.addPassword,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            key: state.pageKey,
            child: AddEditPasswordScreen(
              existingId: args?['id'],
              existingData: args?['data'],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.passwordDetail,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: PasswordDetailScreen(id: args['id'], data: args['data']),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addDocument,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            key: state.pageKey,
            child: AddDocumentScreen(
              existingId: args?['id'],
              existingData: args?['data'],
              documentType: args?['type'],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.documentDetail,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: DocumentDetailScreen(
              id: args['id'],
              documentType: args['type'],
              data: args['data'],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addNote,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            key: state.pageKey,
            child: AddEditNoteScreen(
              existingId: args?['id'],
              existingData: args?['data'],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.noteDetail,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: NoteDetailScreen(id: args['id'], data: args['data']),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addPage,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            key: state.pageKey,
            child: PageEditorScreen(
              existingId: args?['id'],
              existingData: args?['data'],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editPage,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: PageEditorScreen(
              existingId: args['id'],
              existingData: args['data'],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.pageDetail,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: PageViewScreen(id: args['id'], data: args['data']),
          );
        },
      ),

      // Settings sub-screens — platform default (supports back gesture)
      GoRoute(
        path: AppRoutes.securitySettings,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const SecuritySettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.backupSettings,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const BackupSettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.changePin,
        pageBuilder: (_, state) =>
            MaterialPage(key: state.pageKey, child: const ChangePinScreen()),
      ),
    ],
  );
});
