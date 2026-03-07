import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/blurred_text.dart';
import '../../../shared/widgets/privacy_indicator_banner.dart';

class DocumentDetailScreen extends StatefulWidget {
  final int id;
  final String documentType;
  final Map<String, dynamic> data;

  const DocumentDetailScreen({
    super.key,
    required this.id,
    required this.documentType,
    required this.data,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  bool _anySensitiveRevealed = false;

  void _onSensitiveReveal(bool revealed) {
    setState(() {
      _anySensitiveRevealed = revealed;
    });
  }

  String get _title {
    switch (widget.documentType) {
      case AppConstants.docAadhaar:
        return 'Aadhaar Card';
      case AppConstants.docPAN:
        return 'PAN Card';
      case AppConstants.docDebitCard:
        return 'Debit Card';
      case AppConstants.docCreditCard:
        return 'Credit Card';
      default:
        return 'Document';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.documents),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go(AppRoutes.addDocument, extra: {
              'id': widget.id,
              'type': widget.documentType,
              'data': widget.data
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_anySensitiveRevealed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PrivacyIndicatorBanner(
                onHide: () {
                  _onSensitiveReveal(false);
                },
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent() {
    switch (widget.documentType) {
      case AppConstants.docAadhaar:
        return _aadhaarFields();
      case AppConstants.docPAN:
        return _panFields();
      default:
        return _cardFields();
    }
  }

  List<Widget> _aadhaarFields() => [
        _Section(children: [
          _Tile('Full Name', widget.data['holderName'] ?? '', sensitive: false),
          _SensitiveTile('Aadhaar Number', widget.data['aadhaarNumber'] ?? '',
              onReveal: _onSensitiveReveal),
          _Tile('Date of Birth', widget.data['dateOfBirth'] ?? '',
              sensitive: false),
          _Tile('Address', widget.data['address'] ?? '', sensitive: false),
        ]),
        if (widget.data['imageFrontBase64'] != null) ...[
          const SizedBox(height: 16),
          _ImageSection('Front', widget.data['imageFrontBase64'] as String),
        ],
        if (widget.data['imageBackBase64'] != null) ...[
          const SizedBox(height: 16),
          _ImageSection('Back', widget.data['imageBackBase64'] as String),
        ],
        if ((widget.data['notes'] as String? ?? '').isNotEmpty) ...[
          const SizedBox(height: 16),
          _Section(children: [
            _Tile('Notes', widget.data['notes'] ?? '', sensitive: false)
          ]),
        ],
      ];

  List<Widget> _panFields() => [
        _Section(children: [
          _Tile('Full Name', widget.data['holderName'] ?? '', sensitive: false),
          _SensitiveTile('PAN Number', widget.data['panNumber'] ?? '',
              onReveal: _onSensitiveReveal),
          _Tile('Date of Birth', widget.data['dateOfBirth'] ?? '',
              sensitive: false),
          _Tile("Father's Name", widget.data['fatherName'] ?? '',
              sensitive: false),
        ]),
        if (widget.data['imageFrontBase64'] != null) ...[
          const SizedBox(height: 16),
          _ImageSection('Front', widget.data['imageFrontBase64'] as String),
        ],
      ];

  List<Widget> _cardFields() {
    final cardNum = widget.data['cardNumber'] as String? ?? '';
    final masked = cardNum.length >= 4
        ? '•••• •••• •••• ${cardNum.substring(cardNum.length - 4)}'
        : cardNum;
    return [
      _CardPreview(data: widget.data, masked: masked),
      const SizedBox(height: 16),
      _Section(children: [
        _SensitiveTile('Card Number', cardNum, onReveal: _onSensitiveReveal),
        _SensitiveTile('CVV', widget.data['cvv'] ?? '',
            onReveal: _onSensitiveReveal),
        if ((widget.data['pin'] as String? ?? '').isNotEmpty)
          _SensitiveTile('PIN', widget.data['pin']!,
              onReveal: _onSensitiveReveal),
        _Tile('Expiry',
            '${widget.data['expiryMonth'] ?? ''}/${widget.data['expiryYear'] ?? ''}',
            sensitive: false),
        _Tile('Bank', widget.data['bankName'] ?? '', sensitive: false),
        _Tile('Network',
            (widget.data['cardNetwork'] as String? ?? '').toUpperCase(),
            sensitive: false),
      ]),
      if (widget.data['imageFrontBase64'] != null) ...[
        const SizedBox(height: 16),
        _ImageSection('Front', widget.data['imageFrontBase64'] as String),
      ],
      if (widget.data['imageBackBase64'] != null) ...[
        const SizedBox(height: 16),
        _ImageSection('Back', widget.data['imageBackBase64'] as String),
      ],
    ];
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children
            .expand(
                (w) => [w, const Divider(color: AppColors.border, height: 1)])
            .toList()
          ..removeLast(),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final String value;
  final bool sensitive;
  const _Tile(this.label, this.value, {required this.sensitive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        ],
      ),
    );
  }
}

typedef SensitiveRevealCallback = void Function(bool revealed);

class _SensitiveTile extends StatelessWidget {
  final String label;
  final String value;
  final SensitiveRevealCallback? onReveal;
  const _SensitiveTile(this.label, this.value, {this.onReveal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          BlurredText(
            text: value,
            onReveal: onReveal,
          ),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final String label;
  final String imageB64;
  const _ImageSection(this.label, this.imageB64);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label Image',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(base64.decode(imageB64),
              width: double.infinity, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

class _CardPreview extends StatelessWidget {
  final Map<String, dynamic> data;
  final String masked;
  const _CardPreview({required this.data, required this.masked});

  @override
  Widget build(BuildContext context) {
    final network = data['cardNetwork'] as String? ?? '';
    Color bg;
    switch (network) {
      case 'visa':
        bg = const Color(0xFF1A1F71);
        break;
      case 'mastercard':
        bg = const Color(0xFF1B1B1B);
        break;
      case 'rupay':
        bg = const Color(0xFF097969);
        break;
      default:
        bg = AppColors.surfaceLight;
    }
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg, bg.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data['bankName'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(masked,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, letterSpacing: 2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['cardholderName'] ?? '',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              Text('${data['expiryMonth'] ?? ''}/${data['expiryYear'] ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
