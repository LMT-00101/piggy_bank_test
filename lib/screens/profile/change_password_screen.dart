import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final oldPassword = oldPasswordController.text;

    final newPassword = newPasswordController.text;

    final confirmPassword = confirmPasswordController.text;

    if (oldPassword.isEmpty) {
      _showMessage('Vui lòng nhập mật khẩu hiện tại.');
      return;
    }

    if (newPassword.isEmpty) {
      _showMessage('Vui lòng nhập mật khẩu mới.');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('Mật khẩu mới phải có ít nhất 6 ký tự.');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage('Vui lòng xác nhận mật khẩu mới.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Mật khẩu xác nhận không khớp.');
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công.')));

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.lock_outline, size: 64),

          const SizedBox(height: 16),

          const Text(
            'Thay đổi mật khẩu tài khoản',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 28),

          TextField(
            controller: oldPasswordController,
            obscureText: obscureOldPassword,
            decoration: InputDecoration(
              labelText: 'Mật khẩu hiện tại',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureOldPassword = !obscureOldPassword;
                  });
                },
                icon: Icon(
                  obscureOldPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: newPasswordController,
            obscureText: obscureNewPassword,
            decoration: InputDecoration(
              labelText: 'Mật khẩu mới',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureNewPassword = !obscureNewPassword;
                  });
                },
                icon: Icon(
                  obscureNewPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu mới',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Mật khẩu mới cần có ít nhất 6 ký tự.',
            style: TextStyle(fontSize: 13),
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _changePassword,
              child: const Text(
                'Đổi mật khẩu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.forgotPassword);
            },
            child: const Text('Tôi đã quên mật khẩu'),
          ),
        ],
      ),
    );
  }
}
