import 'dart:async';
import 'dart:math';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/help_detail_page.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:ecargo_support/features/help/models/support_model.dart';

class HubPage extends StatefulWidget {
  //final SupportDetailContent? content;
  final HelpDetailPage? content;
  const HubPage({super.key, this.content});

  @override
  State<HubPage> createState() => _SupportDetailPageState();
}

class _SupportDetailPageState extends State<HubPage> {
  bool hasTicket = false;
  bool isLoading = false;
  int currentQueue = 0;
  String generatedTicketNumber = '';
  int userQueueNumber = 0;
  Timer? _timer;
  Duration waitTime = Duration.zero;
  DateTime? ticketCreatedAt;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentQueue = prefs.getInt('currentQueue') ?? 0;
      waitTime = Duration(seconds: prefs.getInt('waitTime') ?? 0);
      hasTicket = prefs.getBool('hasTicket') ?? false;
      generatedTicketNumber = prefs.getString('generatedTicketNumber') ?? '';
      userQueueNumber = prefs.getInt('userQueueNumber') ?? 0;
      final createdAtStr = prefs.getString('ticketCreatedAt');
      if (createdAtStr != null) {
        ticketCreatedAt = DateTime.tryParse(createdAtStr);
      }
    });

    if (hasTicket && waitTime.inSeconds > 0) {
      _startTimer();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentQueue', currentQueue);
    await prefs.setInt('waitTime', waitTime.inSeconds);
    await prefs.setBool('hasTicket', hasTicket);
    await prefs.setString('generatedTicketNumber', generatedTicketNumber);
    await prefs.setInt('userQueueNumber', userQueueNumber);
    if (ticketCreatedAt != null) {
      await prefs.setString(
        'ticketCreatedAt',
        ticketCreatedAt!.toIso8601String(),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (waitTime.inSeconds == 0) {
        timer.cancel();
        return;
      }
      setState(() {
        waitTime -= const Duration(seconds: 1);
      });
      _saveState();
    });
  }

  Future<void> _createTicket() async {
    setState(() => isLoading = true);

    //await Future.delayed(const Duration(seconds: 2));

    final newTicketNumber = _generateTicketNumber();
    final newQueueNumber = currentQueue + 1;
    final createdAt = DateTime.now();
    final estimatedWait = const Duration(hours: 1);
    await Provider.of<TicketProvider>(
      context,
      listen: false,
    ).setTicketNumber(newTicketNumber);

    setState(() {
      hasTicket = true;
      generatedTicketNumber = newTicketNumber;
      userQueueNumber = newQueueNumber;
      ticketCreatedAt = createdAt;
      currentQueue = newQueueNumber;
      waitTime = estimatedWait;
      isLoading = false;
    });
    _startTimer();
    _saveState();
  }

  Future<void> _cancelTicket() async {
    await Provider.of<TicketProvider>(context, listen: false).clearTicket();
    setState(() {
      hasTicket = false;
      generatedTicketNumber = '';
      userQueueNumber = currentQueue - 1;
      currentQueue -= 1;
      ticketCreatedAt = null;
      waitTime = Duration.zero;
    });
    _timer?.cancel();
    _saveState();
  }

  String _generateTicketNumber({int totalLength = 22}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const prefix = 'ECRG';

    final rand = Random();
    final randomLength = totalLength - prefix.length;

    final randomPart = List.generate(
      randomLength,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();

    return '$prefix$randomPart';
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Buat tiket bantuan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004B87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _copyTicketNumber() {
    Clipboard.setData(ClipboardData(text: generatedTicketNumber));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('No. Bantuan disalin')));
  }

  Widget _buildQueueInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFF6F8F9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Antrian saat ini:'),
              const SizedBox(height: 4),
              Text('$currentQueue', style: const TextStyle(fontSize: 18)),
            ],
          ),
          Container(width: 1, height: 40, color: Color(0xFFCECECE)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Waktu tunggu (+-):'),
              Text(
                _formatDuration(waitTime),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${minutes}m : ${seconds}dtk';
  }

  Widget _buildTicketNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No. Bantuan: '),
          GestureDetector(
            onTap: _copyTicketNumber,
            child: Row(
              children: [
                Text(
                  generatedTicketNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Icon(Icons.content_copy, size: 16, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketMessages() {
    final time = ticketCreatedAt != null
        ? '${ticketCreatedAt!.hour.toString().padLeft(2, '0')}:${ticketCreatedAt!.minute.toString().padLeft(2, '0')}'
        : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, top: 16),
          child: Text('Hari ini', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 8),
        _buildMessageBubble('No. Antrian Anda:', '$userQueueNumber', time),
        _buildMessageBubble(
          '',
          'Mohon tunggu, kami akan segera menghubungi Anda kembali.',
          time,
        ),
      ],
    );
  }

  Widget _buildMessageBubble(String title, String content, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) Text(title),
            Container(
              width: 260,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2),
                ],
              ),
              child: Text(content),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: _toggleTicket,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasTicket ? Colors.red : const Color(0xFF004B87),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          hasTicket ? 'Batalkan' : 'Buat Tiket Bantuan',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _toggleTicket() async {
    if (hasTicket) {
      _cancelTicket();
    } else {
      final shouldCreate = await _showConfirmationDialog();
      if (shouldCreate == true) {
        _createTicket();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              child: SvgPicture.asset(
                "assets/images/icons/call.svg",
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Buat Bantuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Ambil antrian Anda dan berbicara dengan CS kami.'),
            const SizedBox(height: 16),
            _buildQueueInfo(),
            if (hasTicket) _buildTicketNumber(),
            const SizedBox(height: 24),
            _buildActionButton(),
            if (hasTicket) _buildTicketMessages(),
          ],
        ),
      ),
    );
  }
}
