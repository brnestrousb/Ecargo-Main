import 'package:flutter/material.dart';

class PilihBahasaPage extends StatefulWidget {
  const PilihBahasaPage({super.key});

  @override
  State<PilihBahasaPage> createState() => _PilihBahasaPageState();
}

class _PilihBahasaPageState extends State<PilihBahasaPage> {
  String? _selectedLanguage = 'id'; // Default Indonesia

  void _onLanguageChanged(String? value) {
    setState(() {
      _selectedLanguage = value;
    });
    // bisa tambahkan logika penyimpanan lokal (SharedPreferences) atau update AppLocale
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLanguageOption(
            title: 'Indonesia',
            flagAsset: '🇮🇩',
            value: 'id',
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            title: 'English (US)',
            flagAsset: '🇺🇸',
            value: 'en',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String flagAsset,
    required String value,
  }) {
    final bool isSelected = _selectedLanguage == value;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _onLanguageChanged(value),
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.blue.shade700, width: 1.5)
              : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedLanguage,
              activeColor: Colors.blue.shade700,
              onChanged: _onLanguageChanged,
            ),
            const SizedBox(width: 8),
            Text(flagAsset, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
