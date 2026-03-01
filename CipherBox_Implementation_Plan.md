# CipherBox — Complete Implementation Plan

**Version:** 1.0
**Date:** February 16, 2026
**Platform:** Flutter (Android + iOS)
**Architecture:** Fully Offline, Zero-Knowledge, Client-Side Encryption

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Technology Stack & Packages](#3-technology-stack--packages)
4. [Folder Structure](#4-folder-structure)
5. [Database Schema (Isar Collections)](#5-database-schema-isar-collections)
6. [Encryption Architecture](#6-encryption-architecture)
7. [Authentication & Security Flow](#7-authentication--security-flow)
8. [Screen-by-Screen Specifications](#8-screen-by-screen-specifications)
9. [Feature Specifications](#9-feature-specifications)
10. [Google Drive Backup System](#10-google-drive-backup-system)
11. [Security Rules & Threat Model](#11-security-rules--threat-model)
12. [Build Phases & Task Breakdown](#12-build-phases--task-breakdown)
13. [Testing Strategy](#13-testing-strategy)
14. [Critical Implementation Notes](#14-critical-implementation-notes)

---

## 1. Project Overview

### 1.1 What is CipherBox?

CipherBox is a fully offline, encrypted personal vault app built with Flutter. It stores three types of sensitive data:

- **Documents** — Aadhaar Card, PAN Card, Debit/Credit Card images and details (including optional PIN)
- **Notes** — Important links and free-form notes
- **Passwords** — Website URL, username, and password combinations

Every piece of data is encrypted on the device using AES-256-GCM before being persisted to the local database. The app never sends plaintext data to any server. Google Drive is used only for encrypted backup files.

### 1.2 Core Principles

- **Zero-Knowledge**: No server ever sees plaintext data. Google Drive stores only encrypted `.cipherbox` backup files.
- **Offline-First**: The app works 100% without internet. Internet is needed only for Google Drive backup/restore.
- **One User Per Device**: Each person installs the app on their own device. No multi-profile switching.
- **Invisible Security**: Authentication (biometric/PIN) is woven into the app experience so it feels seamless, not intrusive.

### 1.3 Auth Model *(Updated: PIN-only, no email/password)*

- **Master PIN**: User creates the vault with a 4–6 digit numeric PIN. No email or password is required. The PIN is used both for authentication AND to derive the Key Encryption Key (KEK).
- **Recovery Phrase**: Generated at setup — 8 groups of 4 alphanumeric characters (e.g. `ABCD-EFGH-JKLM-NPQR-STUV-WXYZ-2345-6789`). This is the ONLY way to reset a forgotten PIN without data loss. Must be written down and stored securely.
- **Biometric** *(optional, recommended)*: After PIN setup, the user can enable fingerprint or Face ID. On subsequent launches, biometric fires automatically during the splash screen.
- **No server, no email**: Vault recovery is fully offline via the recovery phrase. There is no password reset email. Whoever has the recovery phrase can reset the PIN.

### 1.4 Lock Behavior

- **Mobile**: App locks immediately when the user switches away from the app (goes to home screen, switches apps, etc.). On return, biometric or PIN is required.
- **Sensitive Data Reveal**: Individual sensitive fields (card numbers, passwords, PINs) are masked/blurred by default. User taps to reveal, which triggers a quick biometric check. Data auto-hides after 5 seconds.

---

## 2. Architecture Overview

### 2.1 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│              Flutter App (Android + iOS)          │
│                                                   │
│  ┌──────────────────────────────────────────┐    │
│  │           UI Layer (Screens/Widgets)       │    │
│  │  ┌──────────┐ ┌────────┐ ┌────────────┐  │    │
│  │  │Documents │ │ Notes  │ │ Passwords  │  │    │
│  │  │  Vault   │ │ Vault  │ │   Vault    │  │    │
│  │  └──────────┘ └────────┘ └────────────┘  │    │
│  └──────────────────┬───────────────────────┘    │
│                     │                             │
│  ┌──────────────────▼───────────────────────┐    │
│  │        State Management (Riverpod)        │    │
│  └──────────────────┬───────────────────────┘    │
│                     │                             │
│  ┌──────────────────▼───────────────────────┐    │
│  │          Service Layer                    │    │
│  │  ┌───────────┐ ┌──────────┐ ┌─────────┐  │    │
│  │  │  Crypto   │ │  Auth    │ │ Backup  │  │    │
│  │  │  Service  │ │ Service  │ │ Service │  │    │
│  │  └───────────┘ └──────────┘ └─────────┘  │    │
│  └──────────────────┬───────────────────────┘    │
│                     │                             │
│  ┌──────────────────▼───────────────────────┐    │
│  │          Data Layer                       │    │
│  │  ┌────────┐ ┌───────────┐ ┌────────────┐ │    │
│  │  │ Isar   │ │ Encrypted │ │  Flutter   │ │    │
│  │  │  DB    │ │ File Dir  │ │  Secure    │ │    │
│  │  │        │ │ (images)  │ │  Storage   │ │    │
│  │  └────────┘ └───────────┘ └────────────┘ │    │
│  └──────────────────────────────────────────┘    │
│                                                   │
│  ┌──────────────────────────────────────────┐    │
│  │     Google Drive (encrypted backups only)  │    │
│  └──────────────────────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

### 2.2 Data Flow

```
User Input → Riverpod State → Crypto Service (encrypt) → Isar DB (store encrypted blob)
User View  ← Riverpod State ← Crypto Service (decrypt) ← Isar DB (read encrypted blob)
```

Every read and write passes through the Crypto Service. The Isar database never stores plaintext.

---

## 3. Technology Stack & Packages

### 3.1 Flutter Packages

| Package | Version (use latest) | Purpose |
|---------|---------------------|---------|
| `flutter_riverpod` | ^2.x | State management |
| `riverpod_annotation` | ^2.x | Code generation for Riverpod |
| `isar` | ^3.x | Local NoSQL database |
| `isar_flutter_libs` | ^3.x | Isar platform bindings |
| `path_provider` | ^2.x | App directory paths for encrypted file storage |
| `pointycastle` | ^3.x | AES-256-GCM encryption, Argon2id key derivation |
| `flutter_secure_storage` | ^9.x | Store KEK in Android Keystore / iOS Keychain |
| `local_auth` | ^2.x | Biometric authentication (fingerprint / Face ID) |
| `google_sign_in` | ^6.x | Google account auth for Drive access |
| `googleapis` | ^12.x | Google Drive API for backup upload/download |
| `http` | ^1.x | HTTP client for Google API calls |
| `image_picker` | ^1.x | Camera and gallery access for document photos |
| `go_router` | ^13.x | Declarative routing and navigation |
| `flutter_animate` | ^4.x | Splash screen animation, reveal transitions |
| `share_plus` | ^7.x | OS share sheet for manual export |
| `package_info_plus` | ^5.x | App version info for backup metadata |
| `intl` | ^0.19.x | Date and number formatting |
| `uuid` | ^4.x | Generate unique IDs for items |
| `crypto` | ^3.x | SHA-256 for integrity checks (HMAC) |
| `convert` | (dart:convert) | Base64 encoding for images and backup |
| `flutter_slidable` | ^3.x | Swipe-to-delete on list items |
| `pin_code_fields` | ^8.x | PIN entry UI widget |
| `flutter_svg` | ^2.x | SVG icon rendering |

### 3.2 Dev Dependencies

| Package | Purpose |
|---------|---------|
| `isar_generator` | Isar schema code generation |
| `build_runner` | Code generation runner |
| `riverpod_generator` | Riverpod code generation |
| `flutter_test` | Unit and widget testing |
| `integration_test` | Integration testing |
| `mockito` | Mocking for tests |
| `flutter_launcher_icons` | App icon generation |
| `flutter_native_splash` | Native splash screen |

### 3.3 Minimum Platform Versions

- **Android**: minSdkVersion 23 (Android 6.0) — required for biometric APIs and Keystore
- **iOS**: 12.0 — required for local_auth and Keychain access

---

## 4. Folder Structure

```
cipherbox/
├── android/
├── ios/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # MaterialApp + GoRouter setup
│   │
│   ├── core/
│   │   ├── encryption/
│   │   │   ├── crypto_service.dart        # AES-256-GCM encrypt/decrypt operations
│   │   │   ├── key_derivation.dart        # Argon2id / PBKDF2 key derivation
│   │   │   └── key_manager.dart           # KEK lifecycle: generate, wrap, unwrap, rotate
│   │   │
│   │   ├── auth/
│   │   │   ├── auth_service.dart          # Master password verification (local)
│   │   │   ├── biometric_service.dart     # local_auth wrapper for fingerprint/Face ID
│   │   │   ├── pin_service.dart           # PIN setup, verification, storage
│   │   │   └── session_manager.dart       # App lifecycle listener, auto-lock logic
│   │   │
│   │   ├── backup/
│   │   │   ├── backup_service.dart        # Serialize all data → encrypt → .cipherbox file
│   │   │   ├── restore_service.dart       # Read .cipherbox → decrypt → validate → import
│   │   │   ├── google_drive_service.dart  # Upload/download/list files on Google Drive
│   │   │   └── backup_scheduler.dart      # Auto-backup trigger logic + reminders
│   │   │
│   │   ├── database/
│   │   │   ├── isar_service.dart          # Isar initialization + generic CRUD helpers
│   │   │   └── collections/
│   │   │       ├── user_profile.dart      # User profile Isar collection
│   │   │       ├── document_entry.dart    # Document vault Isar collection
│   │   │       ├── note_entry.dart        # Notes vault Isar collection
│   │   │       ├── password_entry.dart    # Password vault Isar collection
│   │   │       └── backup_log.dart        # Backup history Isar collection
│   │   │
│   │   ├── providers/
│   │   │   ├── auth_providers.dart        # Riverpod providers for auth state
│   │   │   ├── crypto_providers.dart      # Riverpod providers for encryption services
│   │   │   ├── vault_providers.dart       # Riverpod providers for vault data
│   │   │   └── backup_providers.dart      # Riverpod providers for backup state
│   │   │
│   │   └── utils/
│   │       ├── constants.dart             # App-wide constants (timeouts, limits, etc.)
│   │       ├── validators.dart            # Input validation (email, password strength, etc.)
│   │       ├── formatters.dart            # Card number masking, date formatting
│   │       └── password_generator.dart    # Random password generation logic
│   │
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── screens/
│   │   │   │   ├── welcome_screen.dart           # Logo + "Get Started" button
│   │   │   │   ├── create_account_screen.dart    # Email + master password setup
│   │   │   │   ├── setup_biometric_screen.dart   # Biometric + PIN setup
│   │   │   │   ├── setup_backup_screen.dart      # Optional Google Drive connect
│   │   │   │   └── setup_complete_screen.dart    # Success + go to home
│   │   │   └── widgets/
│   │   │       ├── password_strength_indicator.dart
│   │   │       └── onboarding_progress_bar.dart
│   │   │
│   │   ├── splash_auth/
│   │   │   ├── screens/
│   │   │   │   ├── splash_screen.dart            # Animated logo + invisible biometric
│   │   │   │   ├── pin_entry_screen.dart         # PIN fallback screen
│   │   │   │   └── password_entry_screen.dart    # Master password fallback screen
│   │   │   └── widgets/
│   │   │       └── logo_animation.dart
│   │   │
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart              # Dashboard with 3 vault cards
│   │   │   └── widgets/
│   │   │       ├── vault_card.dart                # Tappable card for each vault
│   │   │       ├── backup_status_banner.dart      # "Last backup: X days ago"
│   │   │       └── quick_stats_row.dart           # Count of items in each vault
│   │   │
│   │   ├── documents/
│   │   │   ├── screens/
│   │   │   │   ├── documents_list_screen.dart    # List of all stored documents
│   │   │   │   ├── add_document_screen.dart      # Type selector + form
│   │   │   │   ├── add_aadhaar_screen.dart       # Aadhaar-specific form + image
│   │   │   │   ├── add_pan_screen.dart           # PAN-specific form + image
│   │   │   │   ├── add_card_screen.dart          # Debit/Credit card form
│   │   │   │   └── document_detail_screen.dart   # View document with blur/peek
│   │   │   └── widgets/
│   │   │       ├── document_type_selector.dart    # Icon grid to pick doc type
│   │   │       ├── card_preview_widget.dart       # Realistic card preview (masked)
│   │   │       ├── aadhaar_preview_widget.dart    # Aadhaar display widget
│   │   │       └── image_capture_widget.dart      # Camera/gallery picker
│   │   │
│   │   ├── notes/
│   │   │   ├── screens/
│   │   │   │   ├── notes_list_screen.dart        # List of all notes
│   │   │   │   ├── add_edit_note_screen.dart     # Create or edit a note
│   │   │   │   └── note_detail_screen.dart       # View note
│   │   │   └── widgets/
│   │   │       ├── note_card.dart                 # List item preview
│   │   │       └── category_chip.dart             # "Important Link" / "Note" tag
│   │   │
│   │   ├── passwords/
│   │   │   ├── screens/
│   │   │   │   ├── passwords_list_screen.dart    # List of all passwords
│   │   │   │   ├── add_edit_password_screen.dart # Create or edit a password
│   │   │   │   └── password_detail_screen.dart   # View with blur/peek
│   │   │   └── widgets/
│   │   │       ├── password_card.dart             # List item with favicon + URL
│   │   │       ├── password_generator_widget.dart # Generate button + options
│   │   │       └── copy_button.dart               # Copy to clipboard + auto-clear
│   │   │
│   │   └── settings/
│   │       ├── screens/
│   │       │   ├── settings_screen.dart          # Main settings page
│   │       │   ├── security_settings_screen.dart # Biometric, PIN, auto-lock
│   │       │   ├── backup_settings_screen.dart   # Google Drive, auto-backup config
│   │       │   ├── import_export_screen.dart     # Manual import/export
│   │       │   └── change_password_screen.dart   # Change master password
│   │       └── widgets/
│   │           └── settings_tile.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── blurred_text.dart          # Masked text (•••• format) with tap-to-reveal
│   │   │   ├── biometric_gate.dart        # Reusable biometric check wrapper
│   │   │   ├── encrypted_image.dart       # Decrypt + display image widget
│   │   │   ├── empty_state.dart           # "No items yet" placeholder
│   │   │   ├── loading_overlay.dart       # Fullscreen loading indicator
│   │   │   └── confirm_dialog.dart        # Reusable confirmation dialog
│   │   │
│   │   └── theme/
│   │       ├── app_theme.dart             # ThemeData definition
│   │       └── app_colors.dart            # Color palette constants
│   │
│   └── router/
│       └── app_router.dart                # GoRouter configuration
│
├── assets/
│   ├── images/
│   │   ├── logo.svg
│   │   └── onboarding/
│   ├── icons/
│   │   ├── aadhaar_icon.svg
│   │   ├── pan_icon.svg
│   │   ├── card_icon.svg
│   │   ├── note_icon.svg
│   │   └── password_icon.svg
│   └── fonts/                             # If using custom fonts
│
├── test/
│   ├── core/
│   │   ├── encryption/
│   │   │   ├── crypto_service_test.dart
│   │   │   ├── key_derivation_test.dart
│   │   │   └── key_manager_test.dart
│   │   ├── auth/
│   │   │   └── auth_service_test.dart
│   │   └── backup/
│   │       ├── backup_service_test.dart
│   │       └── restore_service_test.dart
│   └── features/
│       └── ... (widget tests per feature)
│
├── integration_test/
│   └── app_test.dart
│
├── pubspec.yaml
└── README.md
```

---

## 5. Database Schema (Isar Collections)

### 5.1 UserProfile *(Updated: PIN-only, no email/password)*

```dart
@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  // PIN verification (primary auth)
  late String pinHash;                 // PBKDF2-SHA256 hash of PIN (for local verification)
  late String pinSalt;                 // Salt for PIN hashing

  // KEK wrapped by PIN-derived key (primary vault access)
  late String wrappedKEK;              // KEK encrypted with PIN-derived key (AES-256-GCM)
  late String kekIV;                   // IV used to decrypt the PIN-wrapped KEK

  // KEK wrapped by recovery phrase-derived key (fallback)
  late String wrappedKEKByRecovery;    // KEK encrypted with Argon2id(recoveryPhrase) key
  late String recoveryKekIV;           // IV used to decrypt the recovery-wrapped KEK
  late String recoveryPhraseHash;      // PBKDF2 hash of recovery phrase (for verification)

  // Settings
  late bool biometricEnabled;          // Whether biometric unlock is enabled
  late bool autoBackupEnabled;         // Whether auto-backup to Google Drive is on
  late String autoBackupFrequency;     // "daily", "weekly", "on_change"

  DateTime? lastBackupDate;
  late DateTime createdAt;
  late DateTime updatedAt;
}
```

### 5.2 DocumentEntry

```dart
@collection
class DocumentEntry {
  Id id = Isar.autoIncrement;

  late String uuid;                     // Unique ID (for backup reconciliation)
  late String documentType;             // "aadhaar", "pan", "debit_card", "credit_card"
  late String encryptedData;            // AES-256-GCM encrypted JSON blob (see structure below)
  late String encryptedItemKey;         // Random item key, wrapped (encrypted) by KEK
  late String itemKeyIV;               // IV used to wrap the item key
  late String dataIV;                  // IV used to encrypt the data blob
  late DateTime createdAt;
  late DateTime updatedAt;
}
```

**Decrypted `encryptedData` JSON structure per document type:**

```json
// Aadhaar Card
{
  "holderName": "Rajesh Kumar",
  "aadhaarNumber": "1234 5678 9012",
  "dateOfBirth": "15/06/1990",
  "address": "123 Main St, City, State",
  "imageFrontBase64": "<base64 encoded image>",
  "imageBackBase64": "<base64 encoded image or null>",
  "notes": "Optional user notes"
}

// PAN Card
{
  "holderName": "Rajesh Kumar",
  "panNumber": "ABCDE1234F",
  "dateOfBirth": "15/06/1990",
  "fatherName": "Suresh Kumar",
  "imageFrontBase64": "<base64 encoded image>",
  "notes": "Optional user notes"
}

// Debit or Credit Card
{
  "cardType": "debit",                    // "debit" or "credit"
  "cardNetwork": "visa",                  // "visa", "mastercard", "rupay", "amex", "other"
  "cardNumber": "4532 1234 5678 9012",
  "cardholderName": "Rajesh Kumar",
  "expiryMonth": "09",
  "expiryYear": "2028",
  "cvv": "123",
  "pin": "1234",                          // OPTIONAL — can be null or empty
  "bankName": "State Bank of India",
  "imageFrontBase64": "<base64 encoded image or null>",
  "imageBackBase64": "<base64 encoded image or null>",
  "notes": "Optional user notes"
}
```

### 5.3 NoteEntry

```dart
@collection
class NoteEntry {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String encryptedData;            // AES-256-GCM encrypted JSON blob
  late String encryptedItemKey;
  late String itemKeyIV;
  late String dataIV;
  late DateTime createdAt;
  late DateTime updatedAt;
}
```

**Decrypted `encryptedData` JSON structure:**

```json
{
  "title": "My Important Link",
  "content": "https://example.com — login portal for XYZ",
  "category": "important_link"           // "important_link" or "note"
}
```

### 5.4 PasswordEntry

```dart
@collection
class PasswordEntry {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String encryptedData;            // AES-256-GCM encrypted JSON blob
  late String encryptedItemKey;
  late String itemKeyIV;
  late String dataIV;
  late DateTime createdAt;
  late DateTime updatedAt;
}
```

**Decrypted `encryptedData` JSON structure:**

```json
{
  "url": "https://gmail.com",
  "siteName": "Gmail",
  "username": "user@gmail.com",
  "password": "s3cur3P@ssw0rd!",
  "notes": "Optional notes"
}
```

### 5.5 BackupLog

```dart
@collection
class BackupLog {
  Id id = Isar.autoIncrement;

  late DateTime backupDate;
  late String destination;               // "google_drive" or "local"
  late int fileSize;                     // in bytes
  late int itemCount;                    // total items backed up
  late String status;                    // "success", "failed", "in_progress"
  late String? errorMessage;             // null if success
  late String? driveFileId;              // Google Drive file ID for deletion management
}
```

---

## 6. Encryption Architecture

### 6.1 Key Hierarchy *(Updated: PIN-primary, recovery phrase fallback)*

```
Master PIN (user enters at setup)
        │
        ▼ PBKDF2-SHA256 (pinSalt, 100,000 iterations)
   PIN Key (256-bit)
        │
        └──▶ Encrypts KEK → stored in UserProfile.wrappedKEK / kekIV

Recovery Phrase (32 alphanumeric chars, generated at setup, shown once)
        │
        ▼ Argon2id (recoverySalt, 2 iterations, 32MB memory, 2 parallelism)
   Recovery Key (256-bit)
        │
        └──▶ Encrypts KEK → stored in UserProfile.wrappedKEKByRecovery / recoveryKekIV

KEK (Key Encryption Key) — 256-bit random key
        │   Generated ONCE at account creation, never changes
        │   Held in memory only while vault is unlocked
        │   Each vault item gets its own random 256-bit Item Key
        │
        ├──▶ wraps Document Item Key → encrypts document JSON blob
        ├──▶ wraps Note Item Key → encrypts note JSON blob
        └──▶ wraps Password Item Key → encrypts password JSON blob

Biometric path:
        KEK → stored in FlutterSecureStorage (hardware-backed keystore)
        Biometric prompt gates access to SecureStorage entry
```

### 6.2 Encryption Operations

**Encrypting a new vault item (e.g., new password entry):**

```
1. Generate random 256-bit Item Key
2. Generate random 96-bit IV (for data encryption)
3. Serialize the data fields to JSON string
4. Encrypt JSON with AES-256-GCM using Item Key + IV → encryptedData
5. Generate random 96-bit IV (for key wrapping)
6. Encrypt Item Key with AES-256-GCM using KEK + IV → encryptedItemKey
7. Store encryptedData, encryptedItemKey, dataIV, itemKeyIV in Isar
```

**Decrypting a vault item:**

```
1. Read encryptedItemKey + itemKeyIV from Isar
2. Decrypt Item Key using KEK + itemKeyIV → Item Key (plaintext)
3. Read encryptedData + dataIV from Isar
4. Decrypt data using Item Key + dataIV → JSON string
5. Parse JSON → display to user
```

**Master password change:**

```
1. User enters old password → derive old encryption key → decrypt KEK
2. User enters new password → derive new encryption key
3. Re-encrypt KEK with new encryption key → update UserProfile.wrappedKEK
4. Update UserProfile.passwordHash with hash of new password
5. Re-encrypt KEK with PIN-derived key → update UserProfile.wrappedKEKByPIN
6. All individual item keys and encrypted data REMAIN UNCHANGED (fast operation)
```

### 6.3 Crypto Service API

```dart
class CryptoService {
  /// Generate a cryptographically secure random key (256-bit)
  Uint8List generateRandomKey();

  /// Generate a random IV (96-bit for GCM)
  Uint8List generateIV();

  /// Derive a master key from password + salt using Argon2id
  /// Returns 512 bits: first 256 for auth hash, last 256 for encryption key
  Uint8List deriveKeyFromPassword(String password, Uint8List salt);

  /// Encrypt plaintext with AES-256-GCM
  /// Returns: {ciphertext: String (base64), iv: String (base64), tag: included in ciphertext}
  EncryptedPayload encrypt(String plaintext, Uint8List key, Uint8List iv);

  /// Decrypt AES-256-GCM ciphertext
  /// Throws AuthenticationException if tampered
  String decrypt(String ciphertext, Uint8List key, Uint8List iv);

  /// Wrap (encrypt) an item key with the KEK
  EncryptedPayload wrapKey(Uint8List itemKey, Uint8List kek, Uint8List iv);

  /// Unwrap (decrypt) an item key using the KEK
  Uint8List unwrapKey(String wrappedKey, Uint8List kek, Uint8List iv);
}
```

### 6.4 Key Manager API

```dart
class KeyManager {
  /// Create a new KEK and wrap it with the password-derived encryption key
  /// Called once during account creation
  Future<void> initializeKeys(String masterPassword, String pin);

  /// Unlock the vault: derive encryption key from password → unwrap KEK → store in memory
  Future<void> unlockWithPassword(String masterPassword);

  /// Unlock the vault using PIN-derived key
  Future<void> unlockWithPIN(String pin);

  /// Unlock the vault using biometric-protected KEK from Secure Storage
  Future<void> unlockWithBiometric();

  /// Store KEK in Flutter Secure Storage (biometric-protected)
  Future<void> storeKEKForBiometric(Uint8List kek);

  /// Get the current in-memory KEK (null if vault is locked)
  Uint8List? get currentKEK;

  /// Lock the vault: clear KEK from memory
  void lock();

  /// Rotate the KEK wrapping on password change
  Future<void> rotatePasswordKey(String oldPassword, String newPassword);
}
```

### 6.5 Biometric Key Storage

```
On biometric setup:
  1. KEK (plaintext) is stored in Flutter Secure Storage
  2. Flutter Secure Storage uses:
     - Android: EncryptedSharedPreferences backed by Android Keystore
     - iOS: Keychain with kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  3. biometric_service.dart wraps local_auth to authenticate before reading

On biometric unlock:
  1. local_auth.authenticate() triggers fingerprint/Face ID
  2. On success → read KEK from Flutter Secure Storage
  3. KEK loaded into memory → vault unlocked
```

---

## 7. Authentication & Security Flow

### 7.1 First Launch (Onboarding) *(Updated: PIN-only flow)*

```
App opens for the first time
    │
    ▼
Welcome Screen
    │ (tap "Get Started")
    ▼
Setup PIN Screen  [/setup-pin]
    │  ├── Enter 6-digit PIN
    │  └── Confirm 6-digit PIN
    │
    ▼ (on confirm PIN match)
    │  1. Generate random 256-bit KEK
    │  2. Derive PIN key: PBKDF2-SHA256(pin, pinSalt, 100k iter)
    │  3. Encrypt KEK with PIN key → wrappedKEK / kekIV
    │  4. Generate 32-char recovery phrase (8×4 alphanumeric groups)
    │  5. Derive recovery key: Argon2id(phrase, recoverySalt)
    │  6. Encrypt KEK with recovery key → wrappedKEKByRecovery / recoveryKekIV
    │  7. Store all in UserProfile; KEK held in memory; store in SecureStorage
    │
    ▼
Setup Recovery Screen  [/setup-recovery]
    │  ├── Display recovery phrase (8 groups of 4 chars)
    │  ├── Copy to clipboard button
    │  └── Checkbox: "I have written it down safely"
    │         (Continue button enabled only after checkbox)
    │
    ▼
Setup Biometric Screen  [/setup-biometric]
    │  ├── Enable biometric (if device supports it)
    │  │     → KEK already in SecureStorage from step 7
    │  └── "Skip" option
    │
    ▼
Setup Google Drive Backup (Optional)  [/setup-backup]
    │
    ▼
Setup Complete → Navigate to Home
```

### 7.2 Subsequent App Launch (Invisible Auth)

```
App opens
    │
    ▼
Splash Screen (logo animation begins, 1.5 seconds)
    │
    ├── Simultaneously: check biometricEnabled
    │
    ├── If biometric enabled:
    │   │  Fire local_auth.authenticate() in background
    │   │
    │   ├── Success → splash dissolves → Home Screen
    │   │   (KEK loaded from Secure Storage)
    │   │
    │   └── Failure / Cancel → splash morphs to PIN Screen
    │
    └── If biometric not enabled:
        │  Splash morphs to PIN Screen after animation
        │
        ├── PIN entered correctly → Home Screen
        │   (KEK unwrapped from wrappedKEKByPIN)
        │
        └── 3 wrong PINs → show Recovery Entry Screen  [/recovery-entry]
            │
            └── Recovery phrase correct → reset PIN → Home Screen
                (KEK unwrapped via recovery key, re-wrapped with new PIN key)
```

### 7.3 App Lifecycle (Auto-Lock)

```dart
// session_manager.dart implements WidgetsBindingObserver

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused ||
      state == AppLifecycleState.inactive ||
      state == AppLifecycleState.hidden) {
    // App moved to background
    _lockVault();
  }

  if (state == AppLifecycleState.resumed) {
    // App returned to foreground
    _showAuthScreen();
  }
}

void _lockVault() {
  // 1. Clear KEK from memory
  keyManager.lock();
  // 2. Clear any revealed sensitive data from screen
  // 3. Set isLocked = true in state
}

void _showAuthScreen() {
  // Navigate to splash_auth flow (biometric → PIN → password)
}
```

### 7.4 Sensitive Data Reveal (Blur & Peek)

```
User sees masked field: •••• •••• •••• 4532
    │
    ▼ (taps eye icon or long-presses)
    │
    ▼
Quick biometric prompt fires (Face ID is < 0.5s)
    │
    ├── Success:
    │   1. Decrypt the specific field
    │   2. Show plaintext with a circular 5-second countdown animation
    │   3. After 5 seconds → auto-mask again
    │   4. Clear plaintext from memory
    │
    └── Failure:
        Show toast "Authentication failed" → field stays masked
```

### 7.5 Vault Recovery via Recovery Phrase *(Updated: replaces OTP flow)*

```
User taps "Forgot PIN? Recover vault" on PIN entry screen
    │
    ▼
Recovery Entry Screen  [/recovery-entry]
    │  ├── Recovery phrase input (XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX)
    │  ├── New PIN input
    │  └── Confirm new PIN input
    │
    ▼ (on submit)
    │  1. Load recoverySalt from FlutterSecureStorage
    │  2. Derive recovery key: Argon2id(phrase, recoverySalt)
    │  3. Verify: PBKDF2(phrase, recoverySalt) == recoveryPhraseHash → if no, show error
    │  4. Decrypt KEK: AES-256-GCM(wrappedKEKByRecovery, recoveryKey, recoveryKekIV)
    │  5. Derive new PIN key: PBKDF2-SHA256(newPIN, newPinSalt)
    │  6. Re-wrap KEK with new PIN key → update UserProfile.wrappedKEK / kekIV
    │  7. KEK held in memory → vault unlocked → navigate to Home
    │
    ▼
Home Screen (vault accessible, existing data unchanged)
```

**KEY ADVANTAGE:** The KEK never changes. Only its wrapping key changes. All existing vault items remain accessible after a PIN reset via recovery phrase — no data loss.

---

## 8. Screen-by-Screen Specifications

### 8.1 Splash Screen

- **Duration**: 1.5 seconds animation minimum
- **Visual**: App logo centered, subtle scale + fade animation
- **Background**: Solid dark color matching theme
- **Behavior**: Biometric fires automatically 0.5s after splash appears. If biometric completes before animation ends, wait for animation to finish, then navigate. This ensures the splash never feels abruptly cut short.
- **Transition**: Smooth fade/dissolve to Home (on success) or slide-up to PIN Screen (on failure).

### 8.2 Home Screen (Dashboard)

**Layout:**
```
┌─────────────────────────────┐
│  CipherBox           [⚙️]   │  ← App name + settings icon
│                              │
│  ┌────────────────────────┐ │
│  │ ⚠️ Last backup: 3 days │ │  ← Yellow/red if > 7 days
│  │     ago. Backup now →   │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │  🗂️  Documents         │ │
│  │  4 items               │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │  📝  Notes             │ │
│  │  12 items              │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │  🔑  Passwords         │ │
│  │  28 items              │ │
│  └────────────────────────┘ │
│                              │
│                      [+ FAB] │  ← Quick add (bottom-right)
└─────────────────────────────┘
```

- **Backup banner**: Shows only if last backup > 3 days. Green = < 3 days. Yellow = 3-7 days. Red = > 7 days.
- **Vault cards**: Tappable, navigates to respective list screens. Shows item count.
- **FAB (Floating Action Button)**: Opens a bottom sheet with 3 options: "Add Document", "Add Note", "Add Password".

### 8.3 Documents List Screen

**Layout:**
```
┌─────────────────────────────┐
│  ← Documents          [+]   │
│                              │
│  ┌────────────────────────┐ │
│  │ 🪪  Aadhaar Card       │ │
│  │    XXXX XXXX 3847      │ │  ← Masked number
│  │    Rajesh Kumar         │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 🏷️  PAN Card           │ │
│  │    XXXXXXX34F           │ │
│  │    Rajesh Kumar         │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 💳  HDFC Debit Card    │ │
│  │    •••• •••• •••• 9012 │ │
│  │    Visa                 │ │
│  └────────────────────────┘ │
└─────────────────────────────┘
```

- List items show document type icon, masked primary identifier, and name
- Swipe left to delete (with confirmation dialog)
- Tap to open detail screen

### 8.4 Document Detail Screen (Example: Credit Card)

**Layout:**
```
┌─────────────────────────────┐
│  ← HDFC Credit Card   [✏️]  │
│                              │
│  ┌────────────────────────┐ │
│  │                        │ │
│  │    HDFC BANK           │ │  ← Realistic card
│  │                        │ │    visual (dark gradient
│  │  •••• •••• •••• 9012   │ │    with masked number)
│  │  RAJESH KUMAR    VISA  │ │
│  │  09/28                 │ │
│  │                        │ │
│  └────────────────────────┘ │
│                              │
│  Card Number                 │
│  •••• •••• •••• 9012   [👁️]  │  ← Tap eye = biometric → reveal 5s
│                              │
│  CVV                         │
│  •••                   [👁️]  │
│                              │
│  PIN                         │
│  ••••                  [👁️]  │
│                              │
│  Expiry                      │
│  09/2028                     │  ← Not sensitive, shown by default
│                              │
│  Bank                        │
│  HDFC Bank                   │
│                              │
│  ┌────────────────────────┐ │
│  │  📷 Front Image   [👁️] │ │  ← Blurred thumbnail, tap to view
│  │  📷 Back Image    [👁️] │ │
│  └────────────────────────┘ │
└─────────────────────────────┘
```

### 8.5 Add Card Screen

**Fields:**
```
Card Type:        [Debit] [Credit]           ← Toggle buttons
Card Network:     [Visa] [MC] [Rupay] [Amex] ← Chips
Card Number:      [________________]          ← Auto-format: XXXX XXXX XXXX XXXX
Cardholder Name:  [________________]
Expiry Month:     [__] / Year: [____]
CVV:              [___]                       ← Max 4 digits
PIN:              [____]                       ← Optional, max 6 digits
Bank Name:        [________________]
Front Image:      [📷 Capture / 🖼️ Gallery]
Back Image:       [📷 Capture / 🖼️ Gallery]   ← Optional
Notes:            [________________]           ← Optional, multiline

                  [💾 Save]
```

**Validation rules:**
- Card number: 13-19 digits (Luhn check optional)
- CVV: 3-4 digits
- PIN: 4-6 digits (if provided)
- Expiry: must be in the future
- Cardholder name: required
- Bank name: required

### 8.6 Passwords List Screen

**Layout:**
```
┌─────────────────────────────┐
│  ← Passwords           [+]  │
│                              │
│  ┌────────────────────────┐ │
│  │ 🌐  Gmail              │ │
│  │     user@gmail.com     │ │
│  │     ••••••••     [📋]  │ │  ← Copy password button
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 🌐  GitHub             │ │
│  │     devuser            │ │
│  │     ••••••••     [📋]  │ │
│  └────────────────────────┘ │
└─────────────────────────────┘
```

- Copy button on the list itself (most common action — user just wants the password quickly)
- Copy triggers biometric → copies to clipboard → auto-clears clipboard after 30 seconds
- Tap the card to open detail screen

### 8.7 Add/Edit Password Screen

**Fields:**
```
Website URL:      [________________]
Site Name:        [________________]          ← Auto-filled from URL if possible
Username/Email:   [________________]
Password:         [________________]  [👁️]

                  [🎲 Generate Password]
                  ┌──────────────────────┐
                  │ Length: [16] ←──→     │
                  │ ☑ Uppercase           │
                  │ ☑ Lowercase           │
                  │ ☑ Numbers             │
                  │ ☑ Symbols             │
                  │ Generated: Kx9$mP2&  │
                  │         [Use This]    │
                  └──────────────────────┘

Notes:            [________________]           ← Optional

                  [💾 Save]
```

### 8.8 Notes List Screen

**Layout:**
```
┌─────────────────────────────┐
│  ← Notes               [+]  │
│                              │
│  ┌────────────────────────┐ │
│  │ 🔗  Bank Portal Login  │ │  ← category: important_link
│  │     https://netbanking… │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 📝  Meeting Notes       │ │  ← category: note
│  │     Discussed Q3 targets│ │
│  └────────────────────────┘ │
└─────────────────────────────┘
```

- Category icon differs: 🔗 for important links, 📝 for notes
- Shows title + first line of content as preview
- Tap to view/edit

### 8.9 Settings Screen

```
┌─────────────────────────────┐
│  ← Settings                  │
│                              │
│  ACCOUNT                     │
│  ┌────────────────────────┐ │
│  │  Email: user@email.com │ │
│  │  Change Master Password│ │
│  └────────────────────────┘ │
│                              │
│  SECURITY                    │
│  ┌────────────────────────┐ │
│  │  Biometric Lock    [✓] │ │
│  │  Change PIN             │ │
│  │  Auto-Lock Timeout      │ │
│  │    → Immediately         │ │  ← Options: Immediately, 30s, 1min, 5min
│  │  Reveal Duration        │ │
│  │    → 5 seconds           │ │  ← How long peek shows data
│  └────────────────────────┘ │
│                              │
│  BACKUP                      │
│  ┌────────────────────────┐ │
│  │  Google Drive     [✓]  │ │
│  │  Auto-Backup: Weekly    │ │
│  │  Last Backup: Feb 14    │ │
│  │  [Backup Now]           │ │
│  └────────────────────────┘ │
│                              │
│  DATA                        │
│  ┌────────────────────────┐ │
│  │  Export Backup          │ │
│  │  Import Backup          │ │
│  └────────────────────────┘ │
│                              │
│  DANGER ZONE                 │
│  ┌────────────────────────┐ │
│  │  🗑️ Delete All Data    │ │  ← Requires master password confirmation
│  └────────────────────────┘ │
│                              │
│  App Version 1.0.0           │
└─────────────────────────────┘
```

---

## 9. Feature Specifications

### 9.1 Password Generator

**Algorithm:**
```
Input: length (8-64), includeUppercase, includeLowercase, includeNumbers, includeSymbols
Output: random password string

Character pools:
  - Uppercase: ABCDEFGHIJKLMNOPQRSTUVWXYZ
  - Lowercase: abcdefghijklmnopqrstuvwxyz
  - Numbers: 0123456789
  - Symbols: !@#$%^&*()_+-=[]{}|;:,.<>?

Algorithm:
  1. Combine enabled character pools
  2. Ensure at least one character from each enabled pool (guarantee complexity)
  3. Fill remaining length with random selections from combined pool
  4. Shuffle the result using Fisher-Yates shuffle
  5. Use dart:math Random.secure() for cryptographic randomness
```

### 9.2 Clipboard Auto-Clear

```dart
// When user copies a password or sensitive field:
void copyToClipboard(String value) {
  Clipboard.setData(ClipboardData(text: value));
  showToast("Copied! Clipboard clears in 30 seconds.");

  Future.delayed(Duration(seconds: 30), () {
    Clipboard.setData(ClipboardData(text: ''));  // Clear clipboard
  });
}
```

### 9.3 Image Handling (Document Photos)

```
Capture/Pick image
    │
    ▼
Compress to max 5MB (quality reduction if needed)
    │
    ▼
Convert to base64 string
    │
    ▼
Include in the document's JSON data blob
    │
    ▼
Entire JSON blob (including base64 image) is encrypted
    │
    ▼
Stored as a single encrypted string in Isar

Display:
    1. Decrypt the JSON blob
    2. Extract base64 image string
    3. Decode base64 → Uint8List
    4. Display with Image.memory()
    5. Show blurred by default → biometric to reveal clear image
```

### 9.4 Auto-Backup Reminder System

```
Backup reminders trigger under these conditions:
  1. After every 5 new items added → subtle banner: "5 new items since last backup"
  2. If auto-backup is OFF and last backup > 7 days → persistent banner on home
  3. If auto-backup fails → notification: "Backup failed. Tap to retry."
  4. On app launch → if last backup > 14 days → modal alert (cannot dismiss without action)

Banner colors:
  - Green: Last backup < 3 days
  - Yellow: Last backup 3-7 days
  - Orange: Last backup 7-14 days
  - Red: Last backup > 14 days or never
```

---

## 10. Google Drive Backup System

### 10.1 Google Drive Setup

```
Google Sign-In Scopes Required:
  - https://www.googleapis.com/auth/drive.file
    (access only to files created by the app)

Folder Structure on Google Drive:
  /CipherBox Backups/
    ├── CipherBox_2026-02-16_14-30-00.cipherbox
    ├── CipherBox_2026-02-09_14-30-00.cipherbox
    ├── CipherBox_2026-02-02_14-30-00.cipherbox
    └── (max 5 files, oldest auto-deleted)
```

### 10.2 Backup File Format (.cipherbox)

The `.cipherbox` file is a single encrypted blob containing all vault data.

**Pre-encryption structure (JSON):**

```json
{
  "version": 1,
  "appVersion": "1.0.0",
  "createdAt": "2026-02-16T14:30:00Z",
  "email": "user@email.com",
  "itemCounts": {
    "documents": 4,
    "notes": 12,
    "passwords": 28
  },
  "data": {
    "documents": [
      {
        "uuid": "abc-123",
        "documentType": "credit_card",
        "encryptedData": "<base64>",
        "encryptedItemKey": "<base64>",
        "itemKeyIV": "<base64>",
        "dataIV": "<base64>",
        "createdAt": "2026-01-10T10:00:00Z",
        "updatedAt": "2026-01-10T10:00:00Z"
      }
    ],
    "notes": [ ... ],
    "passwords": [ ... ]
  },
  "integrity": "<HMAC-SHA256 of data field>"
}
```

**Encryption of the backup file:**

```
1. Serialize the above JSON to string
2. User provides backup password (prompt at export time)
   - Default suggestion: use master password
   - Can be different for extra security
3. Generate random salt (256-bit)
4. Derive backup key from backup password + salt (Argon2id)
5. Generate random IV (96-bit)
6. Encrypt the full JSON string with AES-256-GCM using backup key + IV
7. Construct final file:
   {
     "format": "cipherbox",
     "version": 1,
     "salt": "<base64>",
     "iv": "<base64>",
     "payload": "<base64 encrypted data>"
   }
8. Write to .cipherbox file
```

### 10.3 Backup Process (Code Flow)

```dart
class BackupService {
  /// Create an encrypted backup and upload to Google Drive
  Future<void> backupToGoogleDrive() async {
    // 1. Verify user is authenticated (biometric/PIN)
    // 2. Read all collections from Isar
    // 3. Serialize to backup JSON structure
    // 4. Compute HMAC-SHA256 over data field for integrity
    // 5. Encrypt entire JSON with master-password-derived key
    // 6. Generate filename with timestamp
    // 7. Upload to Google Drive /CipherBox Backups/ folder
    // 8. If > 5 backups exist, delete oldest
    // 9. Log result in BackupLog collection
    // 10. Update UserProfile.lastBackupDate
  }

  /// Create encrypted backup and save to device Downloads folder
  Future<void> backupToLocal() async {
    // Same as above but save to device storage via path_provider
  }
}
```

### 10.4 Restore Process (Code Flow)

```dart
class RestoreService {
  /// Restore from a Google Drive backup
  Future<void> restoreFromGoogleDrive() async {
    // 1. Sign into Google
    // 2. List files in /CipherBox Backups/
    // 3. Show user a list of backups (date, size, item count from filename)
    // 4. User selects one
    // 5. Download the .cipherbox file
    // 6. Prompt for backup password
    // 7. Derive backup key → decrypt payload
    // 8. Verify HMAC integrity
    // 9. Parse JSON
    // 10. Check version compatibility
    // 11. Ask user: "Replace all data?" (since it's a fresh device, auto-replace)
    // 12. Write all collections to Isar
    // 13. Navigate to home
  }

  /// Restore from a local .cipherbox file
  Future<void> restoreFromFile(File file) async {
    // Same as above, starting from step 6
  }
}
```

### 10.5 Auto-Backup Scheduler

```dart
class BackupScheduler {
  /// Called on app launch and after every data modification
  Future<void> checkAndTriggerBackup() async {
    final profile = await isarService.getUserProfile();
    if (!profile.autoBackupEnabled) return;

    final now = DateTime.now();
    final lastBackup = profile.lastBackupDate;
    final frequency = profile.autoBackupFrequency;

    bool shouldBackup = false;

    if (lastBackup == null) {
      shouldBackup = true;
    } else if (frequency == "daily" && now.difference(lastBackup).inDays >= 1) {
      shouldBackup = true;
    } else if (frequency == "weekly" && now.difference(lastBackup).inDays >= 7) {
      shouldBackup = true;
    } else if (frequency == "on_change") {
      // Trigger only if data has changed since last backup
      // Track a "dirty" flag that gets set on any CRUD operation
      shouldBackup = await isarService.isDirty();
    }

    if (shouldBackup) {
      try {
        await backupService.backupToGoogleDrive();
      } catch (e) {
        // Log failure, show notification on next app open
        await isarService.logBackupFailure(e.toString());
      }
    }
  }
}
```

---

## 11. Security Rules & Threat Model

### 11.1 Threat Model

| Threat | Risk Level | Mitigation |
|--------|-----------|------------|
| Device theft | High | Auto-lock on app switch. Biometric/PIN required. KEK in Keystore/Keychain (hardware-backed). Encrypted DB useless without KEK. |
| Device loss + no backup | Critical | Auto-backup reminders. Persistent warnings if no backup exists. |
| Brute-force PIN | Medium | 3 failed PINs → require master password. Argon2id makes key derivation slow (intentionally). |
| Brute-force master password | Low | Argon2id with 64MB memory cost. No remote attack surface (offline app). |
| Shoulder surfing | Medium | Data masked by default. 5-second auto-hide. Biometric required to reveal. |
| Malicious app on same device | Low | Android Keystore / iOS Keychain are process-isolated. Isar DB is app-sandboxed. |
| Google Drive breach | Low | Backup files are AES-256-GCM encrypted. Google sees only opaque blobs. |
| Email compromise (recovery) | High | Recovery resets all data (no decryption possible). Alternative: implement recovery phrase. |
| Clipboard sniffing | Medium | Auto-clear clipboard after 30 seconds. |
| Memory dump | Low | Clear KEK from memory on lock. Dart garbage collection handles the rest. |
| Backup file interception | Low | Backup file is encrypted with user's password-derived key. Useless without password. |

### 11.2 Security Constants

```dart
// constants.dart

class SecurityConstants {
  // Argon2id parameters
  static const int argon2Iterations = 3;
  static const int argon2MemoryKB = 65536;    // 64 MB
  static const int argon2Parallelism = 4;
  static const int argon2KeyLength = 64;       // 512 bits (split into auth + encryption)

  // AES-256-GCM
  static const int aesKeyLength = 32;          // 256 bits
  static const int gcmIVLength = 12;           // 96 bits (standard for GCM)
  static const int gcmTagLength = 16;          // 128 bits

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
  static const int maxImageSizeBytes = 5 * 1024 * 1024;  // 5 MB
  static const int imageCompressionQuality = 80;           // JPEG quality
}
```

---

## 12. Build Phases & Task Breakdown

### Phase 1: Foundation (Week 1)

**Goal:** App skeleton, encryption core, local auth, splash screen.

| # | Task | File(s) | Priority |
|---|------|---------|----------|
| 1.1 | Flutter project setup, packages, folder structure | pubspec.yaml, folder tree | P0 |
| 1.2 | App theme (dark, minimal, Material 3) | app_theme.dart, app_colors.dart | P0 |
| 1.3 | Isar DB initialization + all collections | isar_service.dart, all collection files | P0 |
| 1.4 | CryptoService: AES-256-GCM encrypt/decrypt | crypto_service.dart | P0 |
| 1.5 | KeyDerivation: Argon2id implementation | key_derivation.dart | P0 |
| 1.6 | KeyManager: KEK generation, wrapping, unwrapping | key_manager.dart | P0 |
| 1.7 | AuthService: master password hash/verify | auth_service.dart | P0 |
| 1.8 | BiometricService: local_auth wrapper | biometric_service.dart | P0 |
| 1.9 | PINService: PIN hash/verify + KEK wrapping by PIN | pin_service.dart | P0 |
| 1.10 | Onboarding screens (all 5) | onboarding/ screens | P0 |
| 1.11 | Splash screen with invisible biometric | splash_screen.dart | P0 |
| 1.12 | PIN entry screen | pin_entry_screen.dart | P0 |
| 1.13 | Password entry fallback screen | password_entry_screen.dart | P0 |
| 1.14 | SessionManager: auto-lock on app background | session_manager.dart | P0 |
| 1.15 | GoRouter setup with auth guards | app_router.dart | P0 |
| 1.16 | Riverpod providers for auth state | auth_providers.dart | P0 |
| 1.17 | Unit tests for CryptoService | crypto_service_test.dart | P0 |
| 1.18 | Unit tests for KeyManager | key_manager_test.dart | P0 |

### Phase 2: Password Vault (Week 2)

**Goal:** Full CRUD for password entries with encryption.

| # | Task | File(s) | Priority |
|---|------|---------|----------|
| 2.1 | Home screen with vault cards | home_screen.dart, vault_card.dart | P0 |
| 2.2 | Passwords list screen | passwords_list_screen.dart | P0 |
| 2.3 | Add/Edit password screen | add_edit_password_screen.dart | P0 |
| 2.4 | Password detail screen with blur/peek | password_detail_screen.dart | P0 |
| 2.5 | Password generator widget | password_generator_widget.dart | P0 |
| 2.6 | BlurredText widget (reusable) | blurred_text.dart | P0 |
| 2.7 | BiometricGate widget (reusable) | biometric_gate.dart | P0 |
| 2.8 | Copy to clipboard with auto-clear | copy_button.dart | P1 |
| 2.9 | Swipe-to-delete on list items | passwords_list_screen.dart | P1 |
| 2.10 | Riverpod providers for password vault | vault_providers.dart | P0 |
| 2.11 | Empty state widget | empty_state.dart | P1 |

### Phase 3: Documents Vault (Week 3)

**Goal:** Full CRUD for documents (Aadhaar, PAN, Cards).

| # | Task | File(s) | Priority |
|---|------|---------|----------|
| 3.1 | Documents list screen | documents_list_screen.dart | P0 |
| 3.2 | Add document type selector | add_document_screen.dart, document_type_selector.dart | P0 |
| 3.3 | Add Aadhaar screen + form | add_aadhaar_screen.dart | P0 |
| 3.4 | Add PAN screen + form | add_pan_screen.dart | P0 |
| 3.5 | Add Card screen + form (all fields + optional PIN) | add_card_screen.dart | P0 |
| 3.6 | Image capture/gallery widget | image_capture_widget.dart | P0 |
| 3.7 | Image compression to 5MB limit | image_capture_widget.dart | P0 |
| 3.8 | Document detail screen with blur/peek | document_detail_screen.dart | P0 |
| 3.9 | Card preview widget (realistic card visual) | card_preview_widget.dart | P1 |
| 3.10 | EncryptedImage widget (decrypt + display) | encrypted_image.dart | P0 |
| 3.11 | Input validation (card number, expiry, CVV, etc.) | validators.dart | P0 |
| 3.12 | Card number formatting (auto-space every 4 digits) | formatters.dart | P1 |

### Phase 4: Notes Vault (Week 3-4)

**Goal:** Full CRUD for notes and important links.

| # | Task | File(s) | Priority |
|---|------|---------|----------|
| 4.1 | Notes list screen | notes_list_screen.dart | P0 |
| 4.2 | Add/Edit note screen | add_edit_note_screen.dart | P0 |
| 4.3 | Note detail screen | note_detail_screen.dart | P0 |
| 4.4 | Category chip widget (Link vs Note) | category_chip.dart | P1 |
| 4.5 | Note card widget (list item) | note_card.dart | P1 |

### Phase 5: Backup System (Week 4-5)

**Goal:** Google Drive backup, restore, auto-backup.

| # | Task | File(s) | Priority |
|---|------|---------|----------|
| 5.1 | BackupService: serialize + encrypt to .cipherbox | backup_service.dart | P0 |
| 5.2 | RestoreService: decrypt + validate + import | restore_service.dart | P0 |
| 5.3 | GoogleDriveService: auth + upload + download + list + delete | google_drive_service.dart | P0 |
| 5.4 | Google Sign-In integration | google_drive_service.dart | P0 |
| 5.5 | Backup settings screen | backup_settings_screen.dart | P0 |
| 5.6 | Import/Export screen | import_export_screen.dart | P0 |
| 5.7 | Auto-backup scheduler | backup_scheduler.dart | P1 |
| 5.8 | Backup status banner on home | backup_status_banner.dart | P1 |
| 5.9 | Backup reminder notifications | backup_scheduler.dart | P2 |
| 5.10 | BackupLog tracking | backup_log.dart | P1 |
| 5.11 | Manual export via share sheet | import_export_screen.dart | P1 |
| 5.12 | Restore flow on fresh install | onboarding + restore_service | P0 |
| 5.13 | Unit tests for backup/restore | backup_service_test.dart, restore_service_test.dart | P0 |

### Phase 6: Settings & Polish (Week 5-6)

**Goal:** All settings, password change, edge cases, final polish.

| # | Task | File(s) | Priority |
|---|------|---------|----------|
| 6.1 | Settings screen (all sections) | settings_screen.dart | P0 |
| 6.2 | Change master password flow | change_password_screen.dart | P0 |
| 6.3 | Change PIN flow | security_settings_screen.dart | P1 |
| 6.4 | Toggle biometric on/off | security_settings_screen.dart | P1 |
| 6.5 | Delete all data (with password confirmation) | settings_screen.dart | P0 |
| 6.6 | Splash screen animation polish | logo_animation.dart | P2 |
| 6.7 | Transition animations between screens | app_router.dart | P2 |
| 6.8 | Error handling for all edge cases | All files | P0 |
| 6.9 | Loading states for encrypt/decrypt operations | loading_overlay.dart | P1 |
| 6.10 | App icon design + generation | flutter_launcher_icons config | P1 |
| 6.11 | Native splash screen | flutter_native_splash config | P1 |
| 6.12 | Android/iOS permission handling (camera, biometric) | AndroidManifest.xml, Info.plist | P0 |
| 6.13 | Integration tests (full flow) | app_test.dart | P1 |
| 6.14 | Performance testing (encrypt/decrypt 100+ items) | Manual testing | P1 |

---

## 13. Testing Strategy

### 13.1 Unit Tests (Priority: Critical)

**Encryption tests (crypto_service_test.dart):**
```
- Encrypt then decrypt returns original plaintext
- Decrypt with wrong key throws AuthenticationException
- Decrypt with tampered ciphertext throws AuthenticationException
- Different IVs produce different ciphertexts for same plaintext
- Generated keys are 256 bits
- Generated IVs are 96 bits
```

**Key management tests (key_manager_test.dart):**
```
- KEK wrapping and unwrapping roundtrip succeeds
- Unwrap with wrong password fails
- Password change re-wraps KEK correctly
- Old password cannot unwrap after password change
- PIN wrapping and unwrapping roundtrip succeeds
```

**Key derivation tests (key_derivation_test.dart):**
```
- Same password + salt produces same key (deterministic)
- Different passwords produce different keys
- Different salts produce different keys
- Derived key is correct length (512 bits)
```

**Backup tests (backup_service_test.dart):**
```
- Backup creates valid .cipherbox file
- Restore from backup restores all items correctly
- Backup with wrong password cannot be restored
- Tampered backup file is detected (HMAC check)
- Version compatibility check works
- Large backup (100+ items with images) completes successfully
```

### 13.2 Widget Tests

```
- Onboarding flow: complete account creation
- Password reveal: tap eye → biometric → show for 5s → auto-hide
- PIN entry: 3 failures → redirects to password screen
- Add password: form validation works
- Add card: all fields validate, PIN is optional
- Settings: toggle biometric on/off
```

### 13.3 Integration Tests

```
- Full flow: onboard → add password → lock → unlock → view password
- Full flow: add card with image → close app → reopen → view card
- Full flow: create 10 items → backup to Drive → delete all → restore → verify all 10
- Full flow: change master password → old password rejected → new password works
```

---

## 14. Critical Implementation Notes

### 14.1 Common Pitfalls to Avoid

1. **NEVER log or print encryption keys, plaintext data, or passwords.** Not even in debug mode. Use a flag to conditionally log only non-sensitive metadata.

2. **NEVER store the KEK in Isar or SharedPreferences.** KEK goes ONLY in Flutter Secure Storage (hardware-backed) or stays in memory.

3. **Always generate a NEW random IV for every encryption operation.** Reusing IVs with the same key completely breaks AES-GCM security.

4. **Always use `Random.secure()`** (from `dart:math`) for any cryptographic randomness. Never use `Random()` (unseeded/predictable).

5. **Image compression before encryption.** Compress first, then encode to base64, then encrypt. Not the other way around. Encrypted data cannot be compressed.

6. **Handle Isar transactions carefully.** When saving an encrypted item, write all fields (encryptedData, encryptedItemKey, IVs) in a single transaction. Partial writes could corrupt an entry.

7. **Argon2id may be slow on older devices.** Consider showing a loading indicator during key derivation. On very old Android devices, consider fallback to PBKDF2 with 600,000+ iterations.

8. **Flutter Secure Storage on Android** requires minSdkVersion 23. Older versions fall back to AES encryption with a key stored in SharedPreferences, which is less secure.

9. **Google Drive scope**: Use `drive.file` scope (not `drive`) to only access files created by the app. This is a security best practice and requires fewer permissions.

10. **Base64 image size**: A 5MB image becomes ~6.67MB in base64. Plan for this overhead in backup file size calculations.

### 14.2 Android-Specific Configuration

```xml
<!-- android/app/src/main/AndroidManifest.xml -->

<!-- Required permissions -->
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>  <!-- Only for Google Drive -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<!-- Prevent screenshots and recent apps preview -->
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:windowSecure="true">  <!-- Prevents screenshots -->
```

```kotlin
// MainActivity.kt — add FLAG_SECURE to prevent screenshots
import android.view.WindowManager

override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    window.setFlags(
        WindowManager.LayoutParams.FLAG_SECURE,
        WindowManager.LayoutParams.FLAG_SECURE
    )
}
```

### 14.3 iOS-Specific Configuration

```xml
<!-- ios/Runner/Info.plist -->

<!-- Camera permission -->
<key>NSCameraUsageDescription</key>
<string>CipherBox needs camera access to photograph your documents</string>

<!-- Photo library permission -->
<key>NSPhotoLibraryUsageDescription</key>
<string>CipherBox needs photo access to import document images</string>

<!-- Face ID permission -->
<key>NSFaceIDUsageDescription</key>
<string>CipherBox uses Face ID to securely unlock your vault</string>
```

### 14.4 UI/UX Theme Specifications

```dart
// app_colors.dart
class AppColors {
  // Primary dark theme
  static const Color background = Color(0xFF0D1117);       // Deep dark blue-black
  static const Color surface = Color(0xFF161B22);           // Card background
  static const Color surfaceLight = Color(0xFF21262D);      // Elevated surface
  static const Color primary = Color(0xFF58A6FF);           // Blue accent
  static const Color primaryDark = Color(0xFF1F6FEB);       // Darker blue for buttons
  static const Color success = Color(0xFF3FB950);           // Green (backup OK)
  static const Color warning = Color(0xFFD29922);           // Yellow (backup warning)
  static const Color error = Color(0xFFF85149);             // Red (backup critical)
  static const Color textPrimary = Color(0xFFE6EDF3);       // Main text
  static const Color textSecondary = Color(0xFF8B949E);     // Muted text
  static const Color border = Color(0xFF30363D);            // Subtle borders
  static const Color cardVisa = Color(0xFF1A1F71);          // Visa card gradient
  static const Color cardMastercard = Color(0xFFEB001B);    // MC card gradient
  static const Color cardRupay = Color(0xFF097969);         // RuPay card gradient
}
```

**Design principles:**
- Dark theme only (vault apps should feel dark and secure)
- Minimal use of color — mostly monochrome with blue accent
- Large touch targets (48dp minimum)
- Generous spacing between items
- No unnecessary decorative elements
- Smooth, subtle animations (no flashy transitions)
- Card-based layout throughout
- Consistent 16dp horizontal padding

---

## End of Document

This document contains the complete implementation specification for CipherBox. A coding agent should follow the build phases in order, implementing each task sequentially. The encryption architecture in Section 6 is the most critical section and must be implemented exactly as specified — any deviation could compromise the security model.
