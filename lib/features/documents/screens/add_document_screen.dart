import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/encryption/key_manager.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/storage/encrypted_image_store.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_palette.dart';
import '../widgets/encrypted_image_view.dart';

/// Tracks the state of a single document image slot (front/back) while editing.
class _ImageSlot {
  Map<String, dynamic>? ref; // existing on-disk encrypted ref (unchanged)
  Uint8List? newBytes; // freshly picked bytes to persist on save
  Map<String, dynamic>? pendingDelete; // old ref to remove on save

  bool get hasImage => newBytes != null || ref != null;
}

class AddDocumentScreen extends ConsumerStatefulWidget {
  final int? existingId;
  final Map<String, dynamic>? existingData;
  final String? documentType;

  const AddDocumentScreen(
      {super.key, this.existingId, this.existingData, this.documentType});

  @override
  ConsumerState<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends ConsumerState<AddDocumentScreen> {
  late String _selectedType;
  bool _loading = false;

  // Common fields
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // Aadhaar
  final _aadhaarCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // PAN
  final _panCtrl = TextEditingController();
  final _fatherCtrl = TextEditingController();

  // Card
  final _cardNumCtrl = TextEditingController();
  final _expiryMonCtrl = TextEditingController();
  final _expiryYrCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  String _cardNetwork = AppConstants.cardVisa;
  String _cardType = 'debit';

  // Images
  final _front = _ImageSlot();
  final _back = _ImageSlot();

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.documentType ??
        widget.existingData?['_type'] ??
        AppConstants.docAadhaar;
    if (widget.existingData != null) _fillFromExisting();
  }

  void _fillFromExisting() {
    final d = widget.existingData!;
    _nameCtrl.text = d['holderName'] ?? d['cardholderName'] ?? '';
    _notesCtrl.text = d['notes'] ?? '';
    _aadhaarCtrl.text = d['aadhaarNumber'] ?? '';
    _dobCtrl.text = d['dateOfBirth'] ?? '';
    _addressCtrl.text = d['address'] ?? '';
    _panCtrl.text = d['panNumber'] ?? '';
    _fatherCtrl.text = d['fatherName'] ?? '';
    _cardNumCtrl.text = d['cardNumber'] ?? '';
    _expiryMonCtrl.text = d['expiryMonth'] ?? '';
    _expiryYrCtrl.text = d['expiryYear'] ?? '';
    _cvvCtrl.text = d['cvv'] ?? '';
    _pinCtrl.text = d['pin'] ?? '';
    _bankCtrl.text = d['bankName'] ?? '';
    _cardNetwork = d['cardNetwork'] ?? AppConstants.cardVisa;
    _cardType = d['cardType'] ?? 'debit';
    _loadSlot(_front, d, 'imageFront');
    _loadSlot(_back, d, 'imageBack');
  }

  // Loads an existing image slot, preferring the on-disk ref. Legacy inline
  // base64 is decoded into bytes so it gets migrated to the store on save.
  void _loadSlot(_ImageSlot slot, Map<String, dynamic> d, String key) {
    final ref = d['${key}Ref'];
    if (ref is Map) {
      slot.ref = Map<String, dynamic>.from(ref);
    } else if (d['${key}Base64'] != null) {
      slot.newBytes = base64.decode(d['${key}Base64'] as String);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _notesCtrl,
      _aadhaarCtrl,
      _dobCtrl,
      _addressCtrl,
      _panCtrl,
      _fatherCtrl,
      _cardNumCtrl,
      _expiryMonCtrl,
      _expiryYrCtrl,
      _cvvCtrl,
      _pinCtrl,
      _bankCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(_ImageSlot slot) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: SecurityConstants.imageCompressionQuality,
    );
    if (picked == null) return;
    final bytes = await File(picked.path).readAsBytes();
    if (bytes.length > SecurityConstants.maxImageSizeBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image is too large (max 5MB)')));
      }
      return;
    }
    setState(() {
      if (slot.ref != null) {
        slot.pendingDelete = slot.ref;
        slot.ref = null;
      }
      slot.newBytes = bytes;
    });
  }

  void _clearImage(_ImageSlot slot) {
    setState(() {
      if (slot.ref != null) {
        slot.pendingDelete = slot.ref;
        slot.ref = null;
      }
      slot.newBytes = null;
    });
  }

  Map<String, dynamic> _buildData(
      Map<String, dynamic>? frontRef, Map<String, dynamic>? backRef) {
    switch (_selectedType) {
      case AppConstants.docAadhaar:
        return {
          'holderName': _nameCtrl.text.trim(),
          'aadhaarNumber': _aadhaarCtrl.text.trim(),
          'dateOfBirth': _dobCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'imageFrontRef': frontRef,
          'imageBackRef': backRef,
          'notes': _notesCtrl.text.trim(),
        };
      case AppConstants.docPAN:
        return {
          'holderName': _nameCtrl.text.trim(),
          'panNumber': _panCtrl.text.trim().toUpperCase(),
          'dateOfBirth': _dobCtrl.text.trim(),
          'fatherName': _fatherCtrl.text.trim(),
          'imageFrontRef': frontRef,
          'notes': _notesCtrl.text.trim(),
        };
      default: // debit_card / credit_card
        return {
          'cardType': _cardType,
          'cardNetwork': _cardNetwork,
          'cardNumber': _cardNumCtrl.text.replaceAll(' ', ''),
          'cardholderName': _nameCtrl.text.trim(),
          'expiryMonth': _expiryMonCtrl.text.trim(),
          'expiryYear': _expiryYrCtrl.text.trim(),
          'cvv': _cvvCtrl.text.trim(),
          'pin': _pinCtrl.text.trim(),
          'bankName': _bankCtrl.text.trim(),
          'imageFrontRef': frontRef,
          'imageBackRef': backRef,
          'notes': _notesCtrl.text.trim(),
        };
    }
  }

  // Persists a slot's freshly-picked bytes to the encrypted image store,
  // or keeps the existing ref unchanged.
  Future<Map<String, dynamic>?> _persistSlot(
      _ImageSlot slot, Uint8List kek) async {
    if (slot.newBytes != null) {
      return EncryptedImageStore.instance.save(slot.newBytes!, kek);
    }
    return slot.ref;
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      final kek = KeyManager.instance.currentKEK;
      if (kek == null) throw StateError('Vault is locked');

      final frontRef = await _persistSlot(_front, kek);
      final backRef = await _persistSlot(_back, kek);

      await saveDocument(
        documentType: _selectedType,
        data: _buildData(frontRef, backRef),
        existingId: widget.existingId,
      );

      // Remove any images the user replaced or cleared.
      await EncryptedImageStore.instance.delete(_front.pendingDelete);
      await EncryptedImageStore.instance.delete(_back.pendingDelete);

      ref.invalidate(documentsProvider);
      ref.invalidate(vaultCountsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title:
            Text(widget.existingId != null ? 'Edit Document' : 'Add Document'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeSelector(
                selected: _selectedType,
                onChanged: (t) => setState(() => _selectedType = t),
              ),
              const SizedBox(height: 24),
              ..._buildFormFields(),
              const SizedBox(height: 24),
              _ImagePicker(
                label: 'Front Image',
                bytes: _front.newBytes,
                imageRef: _front.ref,
                onPick: () => _pickImage(_front),
                onClear: () => _clearImage(_front),
              ),
              const SizedBox(height: 12),
              if (_selectedType != AppConstants.docPAN)
                _ImagePicker(
                  label: 'Back Image (optional)',
                  bytes: _back.newBytes,
                  imageRef: _back.ref,
                  onPick: () => _pickImage(_back),
                  onClear: () => _clearImage(_back),
                ),
              const SizedBox(height: 14),
              _tf(_notesCtrl, 'Notes (optional)', maxLines: 3),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    switch (_selectedType) {
      case AppConstants.docAadhaar:
        return [
          _tf(_nameCtrl, 'Full Name'),
          const SizedBox(height: 14),
          _tf(_aadhaarCtrl, 'Aadhaar Number', keyboard: TextInputType.number),
          const SizedBox(height: 14),
          _tf(_dobCtrl, 'Date of Birth (DD/MM/YYYY)'),
          const SizedBox(height: 14),
          _tf(_addressCtrl, 'Address', maxLines: 3),
        ];
      case AppConstants.docPAN:
        return [
          _tf(_nameCtrl, 'Full Name'),
          const SizedBox(height: 14),
          _tf(_panCtrl, 'PAN Number'),
          const SizedBox(height: 14),
          _tf(_dobCtrl, 'Date of Birth (DD/MM/YYYY)'),
          const SizedBox(height: 14),
          _tf(_fatherCtrl, "Father's Name"),
        ];
      default:
        return [
          Row(
            children: [
              Expanded(
                  child: _toggle('Debit', _cardType == 'debit',
                      () => setState(() => _cardType = 'debit'))),
              const SizedBox(width: 10),
              Expanded(
                  child: _toggle('Credit', _cardType == 'credit',
                      () => setState(() => _cardType = 'credit'))),
            ],
          ),
          const SizedBox(height: 14),
          _NetworkSelector(
            selected: _cardNetwork,
            onChanged: (n) => setState(() => _cardNetwork = n),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _cardNumCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [CardNumberFormatter()],
            maxLength: 23,
            style: TextStyle(color: context.palette.textPrimary),
            decoration: const InputDecoration(
                labelText: 'Card Number', counterText: ''),
          ),
          const SizedBox(height: 14),
          _tf(_nameCtrl, 'Cardholder Name'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: _tf(_expiryMonCtrl, 'MM',
                      keyboard: TextInputType.number, maxLen: 2)),
              const SizedBox(width: 10),
              Expanded(
                  flex: 2,
                  child: _tf(_expiryYrCtrl, 'YYYY',
                      keyboard: TextInputType.number, maxLen: 4)),
              const SizedBox(width: 10),
              Expanded(
                  child: _tf(_cvvCtrl, 'CVV',
                      keyboard: TextInputType.number,
                      maxLen: 4,
                      obscure: true)),
            ],
          ),
          const SizedBox(height: 14),
          _tf(_pinCtrl, 'Card PIN (optional)',
              keyboard: TextInputType.number, maxLen: 6, obscure: true),
          const SizedBox(height: 14),
          _tf(_bankCtrl, 'Bank Name'),
        ];
    }
  }

  Widget _tf(TextEditingController ctrl, String label,
      {TextInputType? keyboard,
      int maxLines = 1,
      int? maxLen,
      bool obscure = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      maxLength: maxLen,
      obscureText: obscure,
      style: TextStyle(color: context.palette.textPrimary),
      decoration: InputDecoration(
          labelText: label, counterText: maxLen != null ? '' : null),
    );
  }

  Widget _toggle(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? context.palette.primary.withValues(alpha: 0.15)
              : context.palette.surface,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: active ? context.palette.primary : context.palette.border),
        ),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    color: active ? context.palette.primary : context.palette.textSecondary,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal))),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _TypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final types = [
      (AppConstants.docAadhaar, 'Aadhaar', Icons.badge_outlined),
      (AppConstants.docPAN, 'PAN', Icons.credit_card_outlined),
      (AppConstants.docDebitCard, 'Debit Card', Icons.payment_outlined),
      (AppConstants.docCreditCard, 'Credit Card', Icons.credit_score_outlined),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: types.map((t) {
        final active = selected == t.$1;
        return GestureDetector(
          onTap: () => onChanged(t.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: active
                  ? context.palette.primary.withValues(alpha: 0.15)
                  : context.palette.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: active ? context.palette.primary : context.palette.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(t.$3,
                    size: 16,
                    color:
                        active ? context.palette.primary : context.palette.textSecondary),
                const SizedBox(width: 6),
                Text(t.$2,
                    style: TextStyle(
                        color: active
                            ? context.palette.primary
                            : context.palette.textSecondary,
                        fontSize: 13)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NetworkSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _NetworkSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final networks = [
      (AppConstants.cardVisa, 'Visa'),
      (AppConstants.cardMastercard, 'MC'),
      (AppConstants.cardRupay, 'RuPay'),
      (AppConstants.cardAmex, 'Amex'),
    ];
    return Row(
      children: networks.map((n) {
        final active = selected == n.$1;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(n.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active
                    ? context.palette.primary.withValues(alpha: 0.15)
                    : context.palette.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: active ? context.palette.primary : context.palette.border),
              ),
              child: Text(n.$2,
                  style: TextStyle(
                      color:
                          active ? context.palette.primary : context.palette.textSecondary,
                      fontSize: 12,
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.normal)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final String label;
  final Uint8List? bytes;
  final Map<String, dynamic>? imageRef;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePicker(
      {required this.label,
      this.bytes,
      this.imageRef,
      required this.onPick,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    if (bytes != null || imageRef != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: context.palette.textSecondary, fontSize: 13)),
          const SizedBox(height: 6),
          Stack(
            children: [
              if (bytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(bytes!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheWidth: 720),
                )
              else
                EncryptedImageView(imageRef: imageRef, height: 120),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onClear,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(4),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.palette.border, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                color: context.palette.primary),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: context.palette.textSecondary)),
          ],
        ),
      ),
    );
  }
}
