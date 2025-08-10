import 'package:flutter/material.dart';

class LanguageToggleButton extends StatefulWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageToggleButton({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<LanguageToggleButton> createState() => _LanguageToggleButtonState();
}

class _LanguageToggleButtonState extends State<LanguageToggleButton> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedLocale = widget.currentLocale;
  }

  void _onSelected(Locale locale) {
    setState(() {
      selectedLocale = locale;
    });
    widget.onLocaleChanged(locale);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      onSelected: _onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: Locale('id'),
          child: Text('ID'),
          // Set background putih
          // Flutter versi terbaru tidak langsung mendukung 'color' di sini,
          // jadi kita bisa membungkus child dengan Container
        ),
        PopupMenuItem(
          value: Locale('en'),
          child: Text('EN'),
        ),
      ],
      color: Colors.white, // <--- Ini penting, atur warna popup menu
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFCECECE),
            width: 0.7,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLocale.languageCode.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF6D7882),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF6D7882),
            ),
          ],
        ),
      ),
    );
  }
}
