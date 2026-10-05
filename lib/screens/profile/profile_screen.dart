import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi Smart Jars?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.welcome,
                  (route) => false,
                );
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title sẽ được hoàn thiện ở bước sau.',
        ),
      ),
    );
  }

  void _openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );
  }

  void _openChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChangePasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cá nhân & Cài đặt',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                    child: Icon(
                      Icons.person,
                      size: 38,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nguyễn Văn A',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '0987654321',
                        ),
                        Text(
                          'nguyenvana@example.com',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Tài khoản',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          _ProfileMenuItem(
            icon: Icons.edit_outlined,
            title: 'Chỉnh sửa hồ sơ',
            onTap: _openEditProfile,
          ),

          _ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: _openChangePassword,
          ),

          const SizedBox(height: 20),

          const Text(
            'Tài chính',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          _ProfileMenuItem(
            icon: Icons.account_balance_outlined,
            title: 'Ngân hàng & Ví liên kết',
            onTap: () {
              _showComingSoon(
                'Ngân hàng & Ví liên kết',
              );
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Cài đặt',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_outlined,
              ),
              title: const Text(
                'Thông báo',
              ),
              subtitle: const Text(
                'Nhận nhắc nhở và thông báo từ Smart Jars',
              ),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),

          _ProfileMenuItem(
            icon: Icons.notifications_active_outlined,
            title: 'Cài đặt thông báo',
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.notifications,
              );
            },
          ),

          _ProfileMenuItem(
            icon: Icons.language,
            title: 'Ngôn ngữ',
            trailing: 'Tiếng Việt',
            onTap: () {
              _showComingSoon(
                'Chuyển đổi ngôn ngữ',
              );
            },
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context)
                    .colorScheme
                    .error,
              ),
              title: Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _showLogoutDialog,
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'Smart Jars • Phiên bản demo',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing != null
            ? Text(
                trailing!,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              )
            : const Icon(
                Icons.chevron_right,
              ),
        onTap: onTap,
      ),
    );
  }
}