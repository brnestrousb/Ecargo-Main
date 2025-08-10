import 'dart:async';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmailVerificationSentScreen extends StatefulWidget {
  final String email;

  const EmailVerificationSentScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationSentScreen> createState() =>
      _EmailVerificationSentScreenState();
}

class _EmailVerificationSentScreenState
    extends State<EmailVerificationSentScreen> {
  late Timer _timer;
  Duration _duration = const Duration(minutes: 1, seconds: 50);
  bool _isCountdownDone = false;

  @override

  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        timer.cancel();
        setState(() {
          _isCountdownDone = true;
        });
      } else {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/icons/email_verification_icon.svg',
                      width: 56,
                      height: 56,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Link verifikasi sudah dikirim melalui email:\n ${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Cek email Anda atau spam dan klik link untuk proses verifikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Tidak menerima Link Verifikasi?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Tunggu untuk mengirim Link verifikasi kembali',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  if (!_isCountdownDone)
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        // TODO: tambahkan aksi kirim ulang email di sini
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Link verifikasi dikirim ulang")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Kirim Ulang Link Verifikasi',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // TODO: Tambahkan aksi untuk login dengan cara lain
                    },
                    child: const Text(
                      'Coba log in dengan cara lain',
                      style: TextStyle(fontSize: 14, color: AppColors.blue),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  const Text(
                    'Butuh bantuan untuk log in?',
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Tambahkan aksi untuk kontak
                    },
                    child: const Text(
                      'Kontak kami',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tombol back
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
