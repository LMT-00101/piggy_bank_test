import 'package:flutter/material.dart';

import '../expenses/expenses_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  @override
  Widget build(BuildContext context) {
    final total = demoExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    final categoryTotals =
        <String, double>{};

    for (final expense in demoExpenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) +
              expense.amount;
    }

    final sortedCategories =
        categoryTotals.entries.toList()
          ..sort(
            (a, b) =>
                b.value.compareTo(a.value),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo'),
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
                  const Text(
                    'Tổng chi tiêu tháng này',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatMoney(total),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Dữ liệu được tổng hợp từ các khoản chi hiện có.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Chi tiêu theo danh mục',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...sortedCategories.map(
            (entry) {
              final percent = total == 0
                  ? 0.0
                  : entry.value / total;

              return Card(
                margin:
                    const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            formatMoney(
                              entry.value,
                            ),
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: percent,
                        minHeight: 8,
                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment:
                            Alignment.centerRight,
                        child: Text(
                          '${(percent * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          const Text(
            'Tóm tắt',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Số khoản chi',
                  value:
                      '${demoExpenses.length}',
                  icon: Icons.receipt_long_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  title: 'Trung bình',
                  value: formatMoney(
                    demoExpenses.isEmpty
                        ? 0
                        : total /
                            demoExpenses.length,
                  ),
                  icon: Icons.analytics_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Báo cáo đã sẵn sàng để xuất.',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.file_download_outlined,
            ),
            label: const Text(
              'Xuất báo cáo',
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}