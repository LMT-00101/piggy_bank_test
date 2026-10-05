import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class ExpenseRecord {
  final String id;
  final String category;
  final String note;
  final double amount;
  final String date;
  final String jarName;

  const ExpenseRecord({
    required this.id,
    required this.category,
    required this.note,
    required this.amount,
    required this.date,
    required this.jarName,
  });
}

final List<ExpenseRecord> demoExpenses = [
  const ExpenseRecord(
    id: 'expense_1',
    category: 'Ăn uống',
    note: 'Bữa trưa',
    amount: 150000,
    date: 'Hôm nay',
    jarName: 'Chi tiêu hàng ngày',
  ),
  const ExpenseRecord(
    id: 'expense_2',
    category: 'Mua sắm',
    note: 'WinMart',
    amount: 450000,
    date: 'Hôm qua',
    jarName: 'Chi tiêu hàng ngày',
  ),
  const ExpenseRecord(
    id: 'expense_3',
    category: 'Giải trí',
    note: 'Xem phim',
    amount: 180000,
    date: '20/09/2026',
    jarName: 'Giải trí',
  ),
];

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() =>
      _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String selectedCategory = 'Tất cả';

  final categories = const [
    'Tất cả',
    'Ăn uống',
    'Mua sắm',
    'Hóa đơn',
    'Giải trí',
    'Khác',
  ];

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  List<ExpenseRecord> get filteredExpenses {
    if (selectedCategory == 'Tất cả') {
      return demoExpenses;
    }

    return demoExpenses
        .where(
          (expense) =>
              expense.category == selectedCategory,
        )
        .toList();
  }

  double get totalExpense {
    return filteredExpenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  Future<void> _openAddExpense() async {
    await Navigator.pushNamed(
      context,
      AppRoutes.addExpense,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiêu'),
        actions: [
          IconButton(
            tooltip: 'Quét OCR',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.ocrScan,
              );
            },
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpense,
        icon: const Icon(Icons.add),
        label: const Text('Thêm khoản chi'),
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
                    radius: 26,
                    backgroundColor:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                    child: Icon(
                      Icons.payments_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng chi tiêu',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatMoney(totalExpense),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
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
            'Danh mục',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category =
                    categories[index];

                return ChoiceChip(
                  label: Text(category),
                  selected:
                      selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory =
                          category;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Khoản chi gần đây',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${filteredExpenses.length} khoản',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (filteredExpenses.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Chưa có khoản chi nào.',
                  ),
                ),
              ),
            ),

          ...filteredExpenses.map(
            (expense) => _ExpenseCard(
              expense: expense,
              formatMoney: formatMoney,
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (sheetContext) {
                    return SafeArea(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              expense.category,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Số tiền: ${formatMoney(expense.amount)}',
                            ),
                            Text(
                              'Hũ: ${expense.jarName}',
                            ),
                            Text(
                              'Ngày: ${expense.date}',
                            ),
                            Text(
                              'Ghi chú: ${expense.note.isEmpty ? 'Không có' : expense.note}',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child:
                                  OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    sheetContext,
                                  );
                                },
                                child: const Text(
                                  'Đóng',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final ExpenseRecord expense;
  final String Function(double) formatMoney;
  final VoidCallback onTap;

  const _ExpenseCard({
    required this.expense,
    required this.formatMoney,
    required this.onTap,
  });

  IconData get icon {
    switch (expense.category) {
      case 'Ăn uống':
        return Icons.restaurant_outlined;
      case 'Mua sắm':
        return Icons.shopping_bag_outlined;
      case 'Hóa đơn':
        return Icons.receipt_long_outlined;
      case 'Giải trí':
        return Icons.movie_outlined;
      default:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: scheme.errorContainer,
          child: Icon(
            icon,
            color: scheme.error,
          ),
        ),
        title: Text(
          expense.category,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${expense.note} • ${expense.date}',
        ),
        trailing: Text(
          '-${formatMoney(expense.amount)}',
          style: TextStyle(
            color: scheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}