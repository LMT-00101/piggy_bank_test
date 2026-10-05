import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../routes/app_routes.dart';

class JarDetailScreen extends StatefulWidget {
  const JarDetailScreen({super.key});

  @override
  State<JarDetailScreen> createState() =>
      _JarDetailScreenState();
}

class _JarDetailScreenState
    extends State<JarDetailScreen> {
  String formatMoney(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  void deleteJar(BuildContext context) {
    final store = AppStore.instance;
    final jar = store.selectedJar;

    if (jar == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa hoặc tạm dừng hũ?'),
          content: Text(
            'Bạn có chắc chắn muốn xóa hũ "${jar.name}" không? Thao tác này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                store.deleteJar(jar.id);

                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.jars,
                  (route) =>
                      route.settings.name == AppRoutes.jars,
                );
              },
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final jar = store.selectedJar;

    if (jar == null) {
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy hũ.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(jar.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editJar,
              ).then((_) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              deleteJar(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
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
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text('Số dư hiện tại'),
                  const SizedBox(height: 4),
                  Text(
                    formatMoney(jar.balance),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tỷ lệ phân bổ: ${jar.targetAllocation}%',
                  ),
                  Text(
                    'Trạng thái: ${jar.status}',
                  ),
                  Text(
                    'Mô tả: ${jar.description}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.deposit,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nạp tiền'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.withdraw,
                    );
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Rút tiền'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.transfer,
              );
            },
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Chuyển tiền giữa các hũ'),
          ),

          const SizedBox(height: 24),

          const Text(
            'Lịch sử giao dịch của hũ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Card(
            child: ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Nạp tiền'),
              subtitle: Text(
                'Vietcombank ***8888 → Hũ',
              ),
              trailing: Text('+2.000.000 đ'),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.remove_circle_outline),
              title: Text('Rút tiền'),
              subtitle: Text(
                'Hũ → Vietcombank ***8888',
              ),
              trailing: Text('-500.000 đ'),
            ),
          ),
        ],
      ),
    );
  }
}