import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Untuk SvgPicture

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Profile'),
        backgroundColor: Color(0xFF007AFF), // Warna biru tua
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan logo kredibilitas
            _buildHeader(),

            SizedBox(height: 16.0),

            // Level User (Bronze, Silver, Gold)
            _buildLevelIndicator(),

            SizedBox(height: 16.0),

            // Progress Bar untuk "Paket berhasil terkirim"
            _buildPackageSentProgress(),

            SizedBox(height: 16.0),

            // Progress Bar untuk "Rating"
            _buildRatingProgress(),

            SizedBox(height: 16.0),

            // Template Data: Penghasilan, Pengiriman, Total ikut Lelang
            _buildDataTemplates(),
          ],
        ),
      ),
    );
  }

  // Header dengan logo kredibilitas
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/vendor_silver.svg', // Ganti dengan path file SVG kamu
          width: 50,
          height: 50,
        ),
        SizedBox(width: 8.0),
        Text(
          'Vendor Silver',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Level Indicator (Bronze, Silver, Gold)
  Widget _buildLevelIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLevelCircle(
            'Bronze', 'assets/bronze_icon.svg'), // Ganti dengan path file SVG
        SizedBox(width: 16.0),
        _buildLevelCircle(
            'Silver', 'assets/silver_icon.svg'), // Ganti dengan path file SVG
        SizedBox(width: 16.0),
        _buildLevelCircle(
            'Gold', 'assets/gold_icon.svg'), // Ganti dengan path file SVG
      ],
    );
  }

  // Circle untuk masing-masing level
  Widget _buildLevelCircle(String label, String svgPath) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: Center(
            child: SvgPicture.asset(
              svgPath,
              width: 20,
              height: 20,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  // Progress Bar untuk "Paket berhasil terkirim"
  Widget _buildPackageSentProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Paket berhasil terkirim',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '294',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: 0.735, // 294 / 400
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0'),
            Text('300'),
            Text('400'),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          'Kualifikasi selanjutnya: 1 Juli, 2025',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Progress Bar untuk "Rating"
  Widget _buildRatingProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rating',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '4.9',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: 0.98, // 4.9 / 5.0
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0'),
            Text('4.4'),
            Text('5.0'),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          'Kualifikasi level selanjutnya: 4.4',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {},
          child: Text('Terkualifikasi untuk level selanjutnya'),
        ),
      ],
    );
  }

  // Template Data: Penghasilan, Pengiriman, Total ikut Lelang
  Widget _buildDataTemplates() {
    return Column(
      children: [
        // Penghasilan
        _buildDataCard(
          title: 'Penghasilan',
          subtitle: 'Rp. 489jt / Rp. 500Jt',
          data: [
            {'level': 'Vendor Bronze', 'value': 'Rp. 200.000.000'},
            {'level': 'Vendor Silver', 'value': 'Rp. 500.000.000'},
            {'level': 'Vendor Gold', 'value': 'Rp. 700.000.000'},
          ],
        ),

        SizedBox(height: 16.0),

        // Pengiriman
        _buildDataCard(
          title: 'Pengiriman',
          subtitle: '293',
          data: [
            {'level': 'Vendor Bronze', 'value': '100'},
            {'level': 'Vendor Silver', 'value': '300'},
            {'level': 'Vendor Gold', 'value': '500'},
          ],
        ),

        SizedBox(height: 16.0),

        // Total ikut Lelang
        _buildDataCard(
          title: 'Total ikut lelang',
          subtitle: '384',
          data: [
            {'level': 'Vendor Bronze', 'value': '100'},
            {'level': 'Vendor Silver', 'value': '200'},
            {'level': 'Vendor Gold', 'value': '700'},
          ],
        ),

        SizedBox(height: 16.0),

        ElevatedButton(
          onPressed: () {},
          child: Text('Terkualifikasi untuk level selanjutnya'),
        ),
      ],
    );
  }

  // Card untuk template data
  Widget _buildDataCard({
    required String title,
    required String subtitle,
    required List<Map<String, String>> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              leading: SvgPicture.asset(
                'assets/${item['level']?.toLowerCase()}_icon.svg', // Ganti dengan path file SVG
                width: 20,
                height: 20,
              ),
              title: Text(item['level']!),
              trailing: Text(item['value']!),
            );
          },
        ),
      ],
    );
  }
}
