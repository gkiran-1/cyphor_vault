import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../core/encryption/key_manager.dart';
import '../../../core/storage/encrypted_image_store.dart';
import '../../../shared/theme/app_palette.dart';

/// Displays a document image, loading it lazily and off the UI thread.
///
/// Supports both the new on-disk encrypted format ([imageRef]) and the legacy
/// inline base64 string ([legacyBase64]) so pre-migration documents still work.
/// Images are decoded downscaled via [cacheWidth] to avoid full-resolution
/// decodes that caused jank.
class EncryptedImageView extends StatefulWidget {
  final Map<String, dynamic>? imageRef;
  final String? legacyBase64;
  final double height;
  final int cacheWidth;

  const EncryptedImageView({
    super.key,
    this.imageRef,
    this.legacyBase64,
    this.height = 200,
    this.cacheWidth = 1080,
  });

  @override
  State<EncryptedImageView> createState() => _EncryptedImageViewState();
}

class _EncryptedImageViewState extends State<EncryptedImageView> {
  Future<Uint8List>? _future;

  @override
  void initState() {
    super.initState();
    _future = _resolve();
  }

  Future<Uint8List> _resolve() async {
    if (widget.imageRef != null) {
      final kek = KeyManager.instance.currentKEK;
      if (kek == null) throw StateError('Vault is locked');
      return EncryptedImageStore.instance.load(widget.imageRef!, kek);
    }
    return base64.decode(widget.legacyBase64!);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FutureBuilder<Uint8List>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Container(
              height: widget.height,
              alignment: Alignment.center,
              color: context.palette.surfaceLight,
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: context.palette.primary),
              ),
            );
          }
          if (snap.hasError || snap.data == null) {
            return Container(
              height: widget.height,
              alignment: Alignment.center,
              color: context.palette.surfaceLight,
              child: Icon(Icons.broken_image_outlined,
                  color: context.palette.textSecondary),
            );
          }
          return Image.memory(
            snap.data!,
            width: double.infinity,
            fit: BoxFit.contain,
            cacheWidth: widget.cacheWidth,
            gaplessPlayback: true,
          );
        },
      ),
    );
  }
}
