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

// Slide-in from right (for detail/add routes)
CustomTransitionPage<void> _slidePage(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (_, animation, __, child) => SlideTransition(
      position: Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    ),
  );
}

// Fade (for root-level routes)
CustomTransitionPage<void> _fadePage(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
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
      // Root / auth routes — fade transition
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (_, state) => _fadePage(state.pageKey, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (_, state) => _fadePage(state.pageKey, const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.pinEntry,
        pageBuilder: (_, state) => _fadePage(state.pageKey, const PinEntryScreen()),
      ),
      GoRoute(
        path: AppRoutes.recoveryEntry,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const RecoveryEntryScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (_, state) => _fadePage(state.pageKey, const HomeScreen()),
      ),

      // Onboarding — slide right
      GoRoute(
        path: AppRoutes.setupPin,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const SetupPinScreen()),
      ),
      GoRoute(
        path: AppRoutes.setupRecovery,
        pageBuilder: (_, state) => _slidePage(
          state.pageKey,
          SetupRecoveryScreen(recoveryPhrase: state.extra as String),
        ),
      ),
      GoRoute(
        path: AppRoutes.setupBiometric,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const SetupBiometricScreen()),
      ),
      GoRoute(
        path: AppRoutes.setupBackup,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const SetupBackupScreen()),
      ),
      GoRoute(
        path: AppRoutes.setupComplete,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const SetupCompleteScreen()),
      ),

      // List screens — fade from home
      GoRoute(
        path: AppRoutes.passwords,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const PasswordsListScreen()),
      ),
      GoRoute(
        path: AppRoutes.documents,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const DocumentsListScreen()),
      ),
      GoRoute(
        path: AppRoutes.notes,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const NotesListScreen()),
      ),
      GoRoute(
        path: AppRoutes.pages,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const PagesListScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const SettingsScreen()),
      ),

      // Detail / add / edit routes — slide right
      GoRoute(
        path: AppRoutes.addPassword,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return _slidePage(
            state.pageKey,
            AddEditPasswordScreen(
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
          return _slidePage(
            state.pageKey,
            PasswordDetailScreen(id: args['id'], data: args['data']),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addDocument,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return _slidePage(
            state.pageKey,
            AddDocumentScreen(
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
          return _slidePage(
            state.pageKey,
            DocumentDetailScreen(
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
          return _slidePage(
            state.pageKey,
            AddEditNoteScreen(
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
          return _slidePage(
            state.pageKey,
            NoteDetailScreen(id: args['id'], data: args['data']),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addPage,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return _slidePage(
            state.pageKey,
            PageEditorScreen(
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
          return _slidePage(
            state.pageKey,
            PageEditorScreen(
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
          return _slidePage(
            state.pageKey,
            PageViewScreen(id: args['id'], data: args['data']),
          );
        },
      ),

      // Settings sub-screens — slide right
      GoRoute(
        path: AppRoutes.securitySettings,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const SecuritySettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.backupSettings,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const BackupSettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.changePin,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const ChangePinScreen()),
      ),
    ],
  );
});
