import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpChatPage extends StatelessWidget {
  final String? ticketNumber;

  const HelpChatPage({super.key, this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // custom height
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/icons/arrow_back.svg",
                      width: 10,
                      height: 10,
                      fit: BoxFit.contain,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SvgPicture.asset("assets/images/icons/call.svg", width: 30, height: 30, fit: BoxFit.contain),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "ADI SETIAWAN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFE8EEF4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Customer Service",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF01518D),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "No. Bantuan: $ticketNumber",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.copy, size: 14),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: ticketNumber ?? ""),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Nomor bantuan disalin'),
                                  ),
                                );
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCenterLabel("Hari Ini"),
                ChatBubble(
                  text: "No. Antrian Anda:\n3",
                  time: "19:54",
                  isSender: false,
                ),
                ChatBubble(
                  text: "Mohon tunggu, kami akan segera menghubungi Anda kembali.",
                  time: "19:54",
                  isSender: false,
                ),
                _buildCenterLabel("Belum Terbaca"),
                const Divider(),
                ChatBubble(
                  text: "Hi, apakah ada yang bisa kami bantu? beri tahu kami kendala Anda, jika anda bukti mohon lampirkan.",
                  time: "20:01",
                  isSender: false,
                ),
                ChatBubble(
                  text: "Hi, saya ingin melaporkan masalah pengiriman. Paket saya belum juga sampai padahal status sudah terkirim kemarin.\nBerikut nomor resinya: JNT1234567890",
                  time: "20:02",
                  isSender: true,
                  statusIcon: Icons.done_all,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: SvgPicture.asset(
                              "assets/images/icons/turn_on_camera.svg", 
                              width: 3, 
                              height: 3, 
                              fit: BoxFit.scaleDown),
                            hintText: "Ketik pesan...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(width: 0.5),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            suffixIcon: SvgPicture.asset("assets/images/icons/send.svg", 
                              width: 1, 
                              height: 1, 
                              fit:BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCenterLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0XFFF6F8F9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
          ),
          child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0XFF01518D))),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isSender;
  final IconData? statusIcon;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isSender,
    this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isSender ? 12 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 12),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                if (statusIcon != null) ...[
                  const SizedBox(width: 4),
                  Icon(statusIcon, size: 14, color: Colors.blue),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
