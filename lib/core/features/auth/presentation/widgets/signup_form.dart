import 'package:flutter/material.dart';
import 'package:ecarrgo/core/model/user_role.dart';
import 'package:logger/logger.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserRole role;

  // Common controllers
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  // Separate password controllers for customer and vendor
  final TextEditingController? customerPasswordController;
  final TextEditingController? customerConfirmPasswordController;

  final TextEditingController? vendorPasswordController;
  final TextEditingController? vendorConfirmPasswordController;

  // Vendor-specific controllers (nullable)
  final TextEditingController? companyNameController;
  final TextEditingController? businessLicenseController;
  final TextEditingController? companyEmailController;
  final TextEditingController? companyPhoneController;
  final TextEditingController? companyAddressController;

  // Vehicle type dropdown value for vendor
  final String? selectedVehicleType;
  final ValueChanged<String?>? onVehicleTypeChanged;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.role,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    this.customerPasswordController,
    this.customerConfirmPasswordController,
    this.vendorPasswordController,
    this.vendorConfirmPasswordController,
    this.companyNameController,
    this.businessLicenseController,
    this.companyEmailController,
    this.companyPhoneController,
    this.companyAddressController,
    this.selectedVehicleType,
    this.onVehicleTypeChanged,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isPasswordVisible = false;
  final Logger logger = Logger();

  final List<String> registeredEmails = [
    'test@example.com',
    'user@example.com',
  ];

  final List<String> vehicleTypes = [
    'Pickup',
    'Truk Box',
    'Truk Tangki',
    'Truk Trailer',
    'Van',
  ];

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email wajib diisi';

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';

    if (registeredEmails.contains(value.toLowerCase())) {
      return 'Email sudah terdaftar';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password wajib diisi';

    if (value.length < 8) return 'Password minimal 8 karakter';

    final hasUpper = RegExp(r'[A-Z]');
    final hasLower = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!hasUpper.hasMatch(value)) {
      return 'Harus mengandung huruf kapital (A-Z)';
    }
    if (!hasLower.hasMatch(value)) return 'Harus mengandung huruf kecil (a-z)';
    if (!hasDigit.hasMatch(value)) return 'Harus mengandung angka (0-9)';
    if (!hasSymbol.hasMatch(value)) {
      return 'Disarankan mengandung simbol (!@#\$%^&*)';
    }

    return null;
  }

  String? _requiredValidator(String? value) =>
      value == null || value.isEmpty ? 'Wajib diisi' : null;

  @override
  Widget build(BuildContext context) {
    logger.i('Building SignUpForm for role: ${widget.role}');
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.role == UserRole.customer) ...[
            _buildTextField(
              controller: widget.firstNameController,
              label: 'Nama Depan',
              hint: 'Isi sesuai dengan KTP',
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: widget.lastNameController,
              label: 'Nama Belakang',
              hint: 'Isi sesuai dengan KTP',
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: widget.emailController,
              label: 'Email',
              hint: 'email',
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: widget.phoneController,
              label: 'Nomor Telepon',
              hint: 'nomor telepon',
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
            ),

            // Password for customer
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.customerPasswordController,
              obscureText: !isPasswordVisible,
              cursorColor: Colors.blue,
              decoration: _inputDecoration(
                label: 'Password',
                hint: 'masukan password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: validatePassword,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.customerConfirmPasswordController,
              obscureText: true,
              cursorColor: Colors.blue,
              decoration: _inputDecoration(
                label: 'Konfirmasi Password',
                hint: 'ulangi password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password wajib diisi';
                }
                if (value != widget.customerPasswordController?.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
          ] else if (widget.role == UserRole.vendor) ...[
            // Vendor-specific fields dulu
            const SizedBox(height: 24),
            _buildTextField(
              controller: widget.companyNameController!,
              label: 'Nama Perusahaan',
              hint: 'nama perusahaan',
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: widget.businessLicenseController!,
              label: 'Nomor Izin Usaha',
              hint: 'nomor izin usaha',
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: widget.companyEmailController!,
              label: 'Email Perusahaan',
              hint: 'email perusahaan',
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Telepon Perusahaan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: const Text(
                        '+62',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: widget.companyPhoneController!,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                          hintText: 'nomor telepon perusahaan',
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi';
                          }
                          if (!RegExp(r'^[0-9]{6,}$').hasMatch(value)) {
                            return 'Nomor tidak valid (min. 6 digit)';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: widget.companyAddressController!,
              label: 'Alamat Perusahaan',
              hint: 'alamat perusahaan',
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Jenis Kendaraan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: widget.selectedVehicleType != ''
                      ? widget.selectedVehicleType
                      : null,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // border bawah abu-abu
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    filled: false,
                  ),
                  dropdownColor: Colors.white, // warna background dropdown item
                  hint: const Text(
                    'Pilih jenis kendaraan',
                    style: TextStyle(color: Colors.grey),
                  ),
                  items: vehicleTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: widget.onVehicleTypeChanged,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please select a vehicle type';
                    }
                    return null;
                  },
                ),
              ],
            ),

            // Setelah semua, baru password vendor
            const SizedBox(height: 24),
            TextFormField(
              controller: widget.vendorPasswordController,
              obscureText: !isPasswordVisible,
              cursorColor: Colors.blue,
              decoration: _inputDecoration(
                label: 'Password',
                hint: 'masukan password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: validatePassword,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.vendorConfirmPasswordController,
              obscureText: true,
              cursorColor: Colors.blue,
              decoration: _inputDecoration(
                label: 'Konfirmasi Password',
                hint: 'ulangi password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password wajib diisi';
                }
                if (value != widget.vendorPasswordController?.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.blue,
      decoration: _inputDecoration(label: label, hint: hint),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      hintStyle: TextStyle(
        fontSize: 14,
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(0.6),
      ),
      contentPadding: const EdgeInsets.only(top: 16, bottom: 8),
      suffixIcon: suffixIcon,
    );
  }
}
