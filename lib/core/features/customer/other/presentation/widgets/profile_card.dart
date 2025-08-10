import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String phone;
  final bool isVerified;
  final VoidCallback? onEdit;

  const ProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.isVerified,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar dengan SVG
              ClipOval(
                child: SvgPicture.asset(
                  'assets/images/icons/avatar.svg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name ($role)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(email),
                    Text(phone),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          isVerified ? Icons.verified : Icons.error,
                          color: isVerified ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isVerified ? 'Terverifikasi' : 'Belum Verifikasi',
                          style: TextStyle(
                            fontSize: 13,
                            color: isVerified ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tombol edit di kanan atas card
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap: onEdit,
            child: SvgPicture.asset(
              'assets/images/icons/btn_edit.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}
