import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/formatters.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';

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
  String? _frontImageB64;
  String? _backImageB64;

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
    _frontImageB64 = d['imageFrontBase64'];
    _backImageB64 = d['imageBackBase64'];
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
    ]) c.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isFront) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: SecurityConstants.imageCompressionQuality,
    );
    if (picked == null) return;
    final bytes = await File(picked.path).readAsBytes();
    if (bytes.length > SecurityConstants.maxImageSizeBytes) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image is too large (max 5MB)')));
      return;
    }
    setState(() {
      if (isFront)
        _frontImageB64 = base64.encode(bytes);
      else
        _backImageB64 = base64.encode(bytes);
    });
  }

  Map<String, dynamic> _buildData() {
    switch (_selectedType) {
      case AppConstants.docAadhaar:
        return {
          'holderName': _nameCtrl.text.trim(),
          'aadhaarNumber': _aadhaarCtrl.text.trim(),
          'dateOfBirth': _dobCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'imageFrontBase64': _frontImageB64,
          'imageBackBase64': _backImageB64,
          'notes': _notesCtrl.text.trim(),
        };
      case AppConstants.docPAN:
        return {
          'holderName': _nameCtrl.text.trim(),
          'panNumber': _panCtrl.text.trim().toUpperCase(),
          'dateOfBirth': _dobCtrl.text.trim(),
          'fatherName': _fatherCtrl.text.trim(),
          'imageFrontBase64': _frontImageB64,
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
          'imageFrontBase64': _frontImageB64,
          'imageBackBase64': _backImageB64,
          'notes': _notesCtrl.text.trim(),
        };
    }
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      await saveDocument(
        documentType: _selectedType,
        data: _buildData(),
        existingId: widget.existingId,
      );
      ref.refresh(documentsProvider);
      if (mounted) context.go(AppRoutes.documents);
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            Text(widget.existingId != null ? 'Edit Document' : 'Add Document'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.documents),
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
                imageB64: _frontImageB64,
                onPick: () => _pickImage(true),
                onClear: () => setState(() => _frontImageB64 = null),
              ),
              const SizedBox(height: 12),
              if (_selectedType != AppConstants.docPAN)
                _ImagePicker(
                  label: 'Back Image (optional)',
                  imageB64: _backImageB64,
                  onPick: () => _pickImage(false),
                  onClear: () => setState(() => _backImageB64 = null),
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
            style: const TextStyle(color: AppColors.textPrimary),
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
      style: const TextStyle(color: AppColors.textPrimary),
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
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    color: active ? AppColors.primary : AppColors.textSecondary,
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
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: active ? AppColors.primary : AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(t.$3,
                    size: 16,
                    color:
                        active ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(t.$2,
                    style: TextStyle(
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
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
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: active ? AppColors.primary : AppColors.border),
              ),
              child: Text(n.$2,
                  style: TextStyle(
                      color:
                          active ? AppColors.primary : AppColors.textSecondary,
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
  final String? imageB64;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePicker(
      {required this.label,
      this.imageB64,
      required this.onPick,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    if (imageB64 != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 6),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(base64.decode(imageB64!),
                    height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate_outlined,
                color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
