import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  String selectedTab = "Rekomendasi"; //Default Tab Filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // HEADER ICON
              SvgPicture.asset(
                'assets/images/vendor/auction.svg',
                height: 50,
              ),
              const SizedBox(height: 8),
              const Text(
                "Lelang disekitarmu!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // SEARCH BAR
              Container(
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1), // shadow tipis
                        offset: const Offset(0, 1), // arah shadow ke atas
                        blurRadius: 6, // bikin shadow halus
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Cari lokasi",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 'Rekomendasi';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: selectedTab == 'Rekomendasi'
                                ? const Color(0xFF002D72)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                color: selectedTab == 'Rekomendasi'
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              child: const Text("Rekomendasi"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 'Baru';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: selectedTab == 'Baru'
                                ? const Color(0xFF002D72)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                color: selectedTab == 'Baru'
                                    ? Colors.white
                                    : const Color(0xFF002D72),
                                fontWeight: FontWeight.w500,
                              ),
                              child: const Text("Baru"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // LIST AUCTION ITEMS

              _AuctionItemCard(
                title: "Binus University, Anggrek Campus",
                price: "Rp 2.125.000",
                timeLeft: "4j 15m",
                bids: "7",
                tag: "Reguler",
                distance: "230Km",
                weight: "120Kg",
                category: "Makanan",
                icon: 'assets/images/vendor/food.svg',
                tagColor: Color(0xFFE8EEF4),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AuctionDetailPage()));
                },
              ),

              _AuctionItemCard(
                title: "Marmara Delightful Cake – Ciamis",
                price: "Rp 5.240.100",
                timeLeft: "12j 9m",
                bids: "12",
                tag: "Prioritas",
                distance: "320Km",
                weight: "120Kg",
                category: "Makanan",
                icon: 'assets/images/vendor/food.svg',
                tagColor: Color(0xFFA68B13),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AuctionDetailPage()));
                },
              ),

              _AuctionItemCard(
                title: "Binus University, Anggrek Campus",
                price: "Rp 1.102.000",
                timeLeft: "12j 9m",
                bids: "12",
                tag: "Silver",
                distance: "230Km",
                weight: "120Kg",
                category: "Pakaian",
                icon: 'assets/images/vendor/tshirt.svg',
                tagColor: Color(0xFF6D7882),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AuctionDetailPage()));
                },
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }
}

class _AuctionItemCard extends StatefulWidget {
  final String title, price, timeLeft, bids, tag, distance, weight, category;
  final Color tagColor;
  final String icon;
  final VoidCallback? onTap; // ✅ ganti jadi fungsi callback

  const _AuctionItemCard({
    required this.title,
    required this.price,
    required this.timeLeft,
    required this.bids,
    required this.tag,
    required this.distance,
    required this.weight,
    required this.category,
    required this.tagColor,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_AuctionItemCard> createState() => _AuctionItemCardState();
}

class _AuctionItemCardState extends State<_AuctionItemCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Bungkus seluruh card
      onTap: widget.onTap, // ✅ panggil callback
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TITLE + FAVORITE ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                      color: isLiked ? Colors.red : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // PRICE - TIME - BIDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Penawaran terbaik:",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(widget.price,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF002D72))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Waktu tersisa:",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/vendor/timer.svg'),
                          const SizedBox(width: 2),
                          Text(widget.timeLeft),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Penawaran:",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/vendor/box.svg'),
                          const SizedBox(width: 2),
                          Text(widget.bids),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              // TAGS
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildTag(
                        widget.tag, widget.tagColor, const Color(0xFF01518D)),
                    _buildTag(widget.distance, Colors.white, Colors.black),
                    _buildTag(widget.weight, Colors.white, Colors.black),
                    _buildTag(widget.category, Colors.white, Colors.black,
                        icon: widget.icon),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor,
      {String? icon}) {
    Color? dynamicTextColor;
    if (text.toLowerCase() == "reguler") {
      dynamicTextColor = const Color(0xFF01518D);
    } else if (text.toLowerCase() == "silver" ||
        text.toLowerCase() == "prioritas") {
      dynamicTextColor = Colors.white;
    } else {
      dynamicTextColor = textColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[SvgPicture.asset(icon)],
          const SizedBox(width: 1),
          Text(text,
              style: TextStyle(
                  color: dynamicTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
