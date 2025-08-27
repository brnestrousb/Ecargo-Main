import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Tutup bottom sheet
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Upload foto baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/icons/upload_file.svg",
                  width: 15,
                  height: 15,
                  fit: BoxFit.scaleDown,
                ),
                title: const Text('Upload dari file'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/icons/camera.svg",
                  width: 15,
                  height: 15,
                  fit: BoxFit.scaleDown,
                ),
                title: const Text('Ambil dari kamera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Simpan ke database / API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Akun'),
        leading: IconButton(onPressed: () => Navigator.pop(context), 
        icon: SvgPicture.asset("assets/images/icons/arrow_back.svg")),
        elevation: 1,
      ),
      
      body: Column(
        children: [
          Expanded(child: 
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16), // Sesuaikan radius sudut
                          child: Container(
                            width: 60,  // Sesuaikan ukuran
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0XFFF6F8F9),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
                            ),
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset("assets/images/icons/profile.svg",
                                width: 60, height: 60),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Edit foto', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Depan',
                      hintText: 'Isi sesuai dengan KTP',
                    ),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Belakang',
                      hintText: 'Isi sesuai dengan KTP',
                    ),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'email',
                    ),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 230),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.all(40),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE8EEF4),
                          foregroundColor: Color(0xFF9BAAB7),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Simpan'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      )]
      )
    );
  }
}
