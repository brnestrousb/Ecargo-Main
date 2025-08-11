import 'package:ecarrgo/core/features/customer/other/presentation/help/clippers/header_curve_clipper.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/contact_option.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/help_category_card.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/help_chat_page.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/help_detail_page.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/hub_page.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpHomePage extends StatefulWidget {
  const HelpHomePage({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<HelpHomePage> createState() => _HelpHomePageState();
}

class _HelpHomePageState extends State<HelpHomePage> {
  bool isTicketActive = false;
  String? ticketNumber;

  @override
  void initState() {
    super.initState();
    Provider.of<TicketProvider>(context, listen: false).ticketNumber;
    loadTicketStatus();
  }


  Future<void> loadTicketStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTicket = prefs.getString('generatedTicketNumber');
    if (savedTicket != null && savedTicket.isNotEmpty) {
      setState(() {
        isTicketActive = true;
        ticketNumber = savedTicket;
      });
    }
  }

  Future<void> cancelTicket() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('generatedTicketNumber');
    setState(() {
      isTicketActive = false;
      ticketNumber = "";
    });
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text("Tiket berhasil dibatalkan")));
  }

  void _navigateToHelpDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HelpDetailPage(
          title: 'Bagaimana cara melacak status pengiriman saya?',
          paragraphs: [
            'Setelah Anda melakukan pembayaran dan pesanan berhasil\ndikonfirmasi, sistem akan otomatis mengirimkan nomor resi (tracking \nnumber) melalui halaman Transaksi Anda.',
            'Untuk melacak status pengiriman:',
          ],
          orderedSteps: [
            'Masuk ke menu “Transaksi”',
            'Klik pada detail pesanan tersebut',
            'Gunakan nomor resi untuk pelacakan real-time',
          ],
          description: [
            "Temukan pesanan yang ingin Anda lacak di daftar pesanan Anda.",
            "Anda akan melihat informasi lengkap mengenai status pemesanan, termasuk status pengiriman dan nomor resi.",
            "Beberapa sistem memungkinkan Anda melacak langsung dari aplikasi, sementara lainnya menyediakan tautan ke situs resmi kurir untuk melihat perjalanan paket secara lebih detail.",
          ],
          unorderedSteps: [
            'Paket sedang dikemas',
            'Paket sudah diambil kurir',
            'Dalam perjalanan',
            'Sedang dikirim',
            'Telah diterima',
          ],
          closingNote:
              'Jika status tidak berubah dalam waktu lama, Anda bisa menggunakan fitur "Buat Bantuan" untuk menghubungi tim layanan pelanggan.',
        ),
      ),
    );
  }

  List<HelpCategoryCard> _buildHelpCategories(BuildContext context) {
    return [
      HelpCategoryCard(
        icon: SvgPicture.asset(
          'assets/images/icons/pengiriman.svg',
          width: 1.5,
          height: 1.5,
        ),
        title: 'Pengiriman',
        question: 'Bagaimana cara melacak status pengiriman saya?',
        onTap: () => _navigateToHelpDetail(context),
      ),
      HelpCategoryCard(
        icon: SvgPicture.asset(
          'assets/images/icons/lelang.svg',
          width: 1.5,
          height: 1.5,
        ),
        title: 'Lelang',
        question: 'Bagaimana cara mengikuti lelang?',
        onTap: () {},
      ),
      HelpCategoryCard(
        icon: SvgPicture.asset(
          'assets/images/icons/transaksi.svg',
          width: 1.5,
          height: 1.5,
        ),
        title: 'Transaksi',
        question: 'Bagaimana cara melihat riwayat transaksi?',
        onTap: () {},
      ),
      HelpCategoryCard(
        icon: SvgPicture.asset(
          'assets/images/icons/kurir.svg',
          width: 1.5,
          height: 1.5,
        ),
        title: 'Kurir',
        question: 'Kurir mana saja yang tersedia?',
        onTap: () {},
      ),
    ];
  }

  Widget _buildTopHeader(BuildContext context) {
    final String? numberActive = context.watch<TicketProvider>().ticketNumber;
    return ClipPath(
      clipper: HeaderCurveClipper(),
      child: Container(
        width: double.infinity,
        height: 400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007BFF), Color(0xFF0056D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        spreadRadius: 8,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/arrow_back.svg',
                      width: 15,
                      height: 15,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bagaimana kami bisa membantu anda?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ContactOption(
                    iconPath: 'assets/images/icons/call.svg',
                    label: 'Hubungi\nKami',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HubPage()),
                    ),
                  ),
                ),
                Expanded(
                  child: ContactOption(
                    iconPath: 'assets/images/icons/whatsapp.svg',
                    label: 'Whatsapp',
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: ContactOption(
                    iconPath: 'assets/images/icons/history.svg',
                    label: 'Riwayat\nBantuan',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Cari Masalah Anda..",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (numberActive != null) _buildTicketButton(context, numberActive),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketButton(BuildContext context, String? numberActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpChatPage(ticketNumber: numberActive!),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF0CD33),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/icons/note.svg",
                    width: 12,
                    height: 12,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bantuan Anda: $numberActive',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helpCategories = _buildHelpCategories(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: helpCategories.length,
                  itemBuilder: (context, index) => helpCategories[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
