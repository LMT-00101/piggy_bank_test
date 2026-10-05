import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final nameController =
      TextEditingController(
    text: 'Nguyễn Văn A',
  );

  final phoneController =
      TextEditingController(
    text: '0987654321',
  );

  final emailController =
      TextEditingController(
    text: 'nguyenvana@example.com',
  );

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty) {
      _showMessage('Vui lòng nhập họ và tên.');
      return;
    }

    if (phone.isEmpty) {
      _showMessage('Vui lòng nhập số điện thoại.');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Vui lòng nhập email.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã cập nhật thông tin hồ sơ.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa hồ sơ',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 46,
              backgroundColor:
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer,
              child: Icon(
                Icons.person,
                size: 52,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
          ),

          const SizedBox(height: 28),

          TextField(
            controller: nameController,
            textInputAction:
                TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Họ và tên',
              prefixIcon:
                  Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            keyboardType:
                TextInputType.phone,
            textInputAction:
                TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Số điện thoại',
              prefixIcon:
                  Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            keyboardType:
                TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon:
                  Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _saveProfile,
              child: const Text(
                'Lưu thay đổi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}