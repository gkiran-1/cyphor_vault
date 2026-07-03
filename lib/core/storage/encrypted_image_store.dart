import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../encryption/crypto_service.dart';

/// Stores document images as individually-encrypted files on disk, keeping
/// them out of the document's main encrypted JSON blob. This makes the
/// documents *list* fast (it no longer decrypts image bytes) and lets the
/// detail screen load images lazily, off the UI thread.
///
/// Each image is encrypted with its own random item key, which is wrapped by
/// the KEK — preserving the zero-knowledge guarantee. The wrapped key + IVs
/// live in a small [ImageRef] map embedded in the document data.
class EncryptedImageStore {
  EncryptedImageStore._();
  static final EncryptedImageStore instance = EncryptedImageStore._();

  Directory? _dir;

  Future<Directory> _imagesDir() async {
    if (_dir != null) return _dir!;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/doc_images');
    if (!await dir.exists()) await dir.create(recursive: true);
    _dir = dir;
    return dir;
  }

  /// Encrypts [bytes] to a new file and returns the small reference map to be
  /// stored inside the document data.
  Future<Map<String, String>> save(Uint8List bytes, Uint8List kek) async {
    final crypto = CryptoService.instance;
    final itemKey = crypto.generateRandomKey();
    final dataIV = crypto.generateIV();
    final keyIV = crypto.generateIV();

    final ciphertext = crypto.encryptBytes(bytes, itemKey, dataIV);
    final wrapped = crypto.wrapKey(itemKey, kek, keyIV);

    final fileUuid = const Uuid().v4();
    final dir = await _imagesDir();
    await File('${dir.path}/$fileUuid.enc').writeAsBytes(ciphertext, flush: true);

    return {
      'file': fileUuid,
      'k': wrapped.ciphertext,
      'kiv': base64.encode(keyIV),
      'div': base64.encode(dataIV),
    };
  }

  /// Loads and decrypts the image referenced by [ref], off the UI thread.
  Future<Uint8List> load(Map<String, dynamic> ref, Uint8List kek) async {
    final dir = await _imagesDir();
    final path = '${dir.path}/${ref['file']}.enc';
    return compute(_decryptImageIsolate, <String, dynamic>{
      'path': path,
      'kek': kek,
      'k': ref['k'],
      'kiv': ref['kiv'],
      'div': ref['div'],
    });
  }

  /// Deletes the backing file for [ref], if any.
  Future<void> delete(Map<String, dynamic>? ref) async {
    if (ref == null || ref['file'] == null) return;
    final dir = await _imagesDir();
    final file = File('${dir.path}/${ref['file']}.enc');
    if (await file.exists()) await file.delete();
  }
}

/// Runs in a background isolate (via [compute]): reads the encrypted file and
/// decrypts it. [CryptoService] is stateless, so a fresh instance in the
/// isolate works fine.
Uint8List _decryptImageIsolate(Map<String, dynamic> args) {
  final ciphertext = File(args['path'] as String).readAsBytesSync();
  final kek = args['kek'] as Uint8List;
  final crypto = CryptoService.instance;
  final itemKey =
      crypto.unwrapKey(args['k'] as String, kek, base64.decode(args['kiv'] as String));
  return crypto.decryptBytes(
    Uint8List.fromList(ciphertext),
    itemKey,
    base64.decode(args['div'] as String),
  );
}
