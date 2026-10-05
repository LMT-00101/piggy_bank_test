import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../routes/app_routes.dart';
import '../transactions/withdraw_screen.dart';
import '../expenses/add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatMoney(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào,',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  'Nguyễn Văn A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.notifications,
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 4),

          _AssetCard(
            totalSavings: formatMoney(store.totalSavings),
            jarCount: store.jars.length,
            spent: formatMoney(store.currentSpentMonth),
          ),

          const SizedBox(height: 16),

          const Text(
            'Thao tác nhanh',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickAction(
                icon: Icons.add,
                label: 'Nạp tiền',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.deposit,
                  );
                },
              ),
              _QuickAction(
                icon: Icons.remove,
                label: 'Rút tiền',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const WithdrawScreen(),
                    ),
                  );
                },
              ),
              _QuickAction(
                icon: Icons.receipt_long,
                label: 'Thêm chi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AddExpenseScreen(),
                    ),
                  );
                },
              ),
              _QuickAction(
                icon: Icons.camera_alt_outlined,
                label: 'Quét OCR',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.ocrScan,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hũ tiết kiệm nổi bật',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.jars,
                  );
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),

          const SizedBox(height: 4),

          ...store.jars.take(3).map(
                (jar) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _JarPreviewCard(
                    name: jar.name,
                    allocation: jar.targetAllocation,
                    status: jar.status,
                    balance: formatMoney(jar.balance),
                    onTap: () {
                      store.selectedJarId = jar.id;

                      Navigator.pushNamed(
                        context,
                        AppRoutes.jarDetail,
                      );
                    },
                  ),
                ),
              ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chi tiêu gần đây',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.expenses,
                  );
                },
                child: const Text('Chi tiết'),
              ),
            ],
          ),

          const _ExpensePreview(
            category: 'Ăn uống',
            note: 'Bữa trưa',
            amount: '-150.000 đ',
            date: 'Hôm nay',
          ),

          const _ExpensePreview(
            category: 'Mua sắm',
            note: 'WinMart',
            amount: '-450.000 đ',
            date: 'Hôm qua',
          ),

          const _ExpensePreview(
            category: 'Giải trí',
            note: 'Xem phim',
            amount: '-180.000 đ',
            date: '20/09/2026',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  final String totalSavings;
  final int jarCount;
  final String spent;

  const _AssetCard({
    required this.totalSavings,
    required this.jarCount,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng tài sản tiết kiệm',
              style: TextStyle(
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              totalSavings,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Số hũ hoạt động'),
                    Text(
                      '$jarCount hũ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    const Text('Đã chi tháng này'),
                    Text(
                      spent,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  scheme.primaryContainer,
              child: Icon(
                icon,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JarPreviewCard extends StatelessWidget {
  final String name;
  final int allocation;
  final String status;
  final String balance;
  final VoidCallback onTap;

  const _JarPreviewCard({
    required this.name,
    required this.allocation,
    required this.status,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.savings,
                  color: scheme.secondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tỷ lệ: $allocation% • $status',
                      style: TextStyle(
                        color:
                            scheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                balance,
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpensePreview extends StatelessWidget {
  final String category;
  final String note;
  final String amount;
  final String date;

  const _ExpensePreview({
    required this.category,
    required this.note,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.surfaceContainerHighest
          .withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: scheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: scheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
