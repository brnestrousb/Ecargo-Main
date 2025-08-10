import 'package:ecarrgo/core/features/customer/presentation/widgets/custom_tab_navigation.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedTab = 'Baru';
  final List<String> tabs = ['Baru', 'Terbaca'];
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> notifications = [
    {
      'title': 'Pesanan Dikirim',
      'message': 'Pesanan #123 telah dikirim ke tujuan.',
      'time': '2 jam yang lalu',
      'status': 'Baru',
    },
    {
      'title': 'Pembayaran Berhasil',
      'message': 'Pembayaran untuk pesanan #122 berhasil.',
      'time': '5 jam yang lalu',
      'status': 'Terbaca',
    },
    {
      'title': 'Pesanan Baru',
      'message': 'Pesanan #124 baru saja dibuat.',
      'time': 'Kemarin',
      'status': 'Baru',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final newNotifications =
        notifications.where((notif) => notif['status'] == 'Baru').toList();
    final readNotifications =
        notifications.where((notif) => notif['status'] == 'Terbaca').toList();

    final filteredNotifications = notifications.where((notif) {
      final matchesTab = notif['status'] == selectedTab;
      final matchesSearch = (notif['title'] ?? '')
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          (notif['message'] ?? '')
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
      return matchesTab && matchesSearch;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            const Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Tab Navigation
            CustomTabNavigation(
              tabs: ['Baru', 'Terbaca'],
              selectedTab: selectedTab,
              onTabSelected: (tab) {
                setState(() {
                  selectedTab = tab;
                });
              },
              tabCounts: {
                'Baru': newNotifications.length,
                'Terbaca': readNotifications.length,
              },
            ),

            const SizedBox(height: 16),

            // Search bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari notifikasi...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            // Total Notifikasi
            Text(
              'Total $selectedTab (${filteredNotifications.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Notifikasi List
            Expanded(
              child: filteredNotifications.isEmpty
                  ? const Center(child: Text('Tidak ada notifikasi.'))
                  : ListView.builder(
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notif = filteredNotifications[index];
                        return Card(
                          elevation: 1,
                          color: Colors.white, // ⬅️ Tambahkan ini
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text(notif['title'] ?? ''),
                            subtitle: Text(notif['message'] ?? ''),
                            trailing: Text(
                              notif['time'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
