import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import 'expense_record.dart';

export 'expense_record.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    expenseRecords.addListener(_onExpensesChanged);
  }

  @override
  void dispose() {
    expenseRecords.removeListener(_onExpensesChanged);
    super.dispose();
  }

  void _onExpensesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  final categories = const [
    'Tất cả',
    'Ăn uống',
    'Mua sắm',
    'Hóa đơn',
    'Giải trí',
    'Khác',
  ];

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')} đ';
  }

  List<ExpenseRecord> get filteredExpenses {
    final expenses = expenseRecords.value;
    if (selectedCategory == 'Tất cả') {
      return expenses;
    }

    return expenses
        .where((expense) => expense.category == selectedCategory)
        .toList();
  }

  double get totalExpense {
    return filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void _openAddExpense() {
    Navigator.pushNamed(context, AppRoutes.addExpense);
  }

  void _openEditExpense(ExpenseRecord expense) {
    Navigator.pushNamed(context, AppRoutes.addExpense, arguments: expense);
  }

  Future<void> _deleteExpense(ExpenseRecord expense) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa khoản chi?'),
          content: const Text('Khoản chi này sẽ bị xóa khỏi danh sách.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    expenseRecords.value = expenseRecords.value
        .where((item) => item.id != expense.id)
        .toList();
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
              Navigator.pushNamed(context, AppRoutes.ocrScan);
            },
            icon: const Icon(Icons.camera_alt_outlined),
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
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.payments_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tổng chi tiêu'),
                        const SizedBox(height: 4),
                        Text(
                          formatMoney(totalExpense),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];

                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Khoản chi gần đây',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${filteredExpenses.length} khoản',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (filteredExpenses.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Chưa có khoản chi nào.')),
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
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.category,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('Số tiền: ${formatMoney(expense.amount)}'),
                            Text('Hũ: ${expense.jarName}'),
                            Text('Ngày: ${expense.date}'),
                            Text(
                              'Ghi chú: ${expense.note.isEmpty ? 'Không có' : expense.note}',
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(sheetContext);
                                      _openEditExpense(expense);
                                    },
                                    child: const Text('Sửa'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      Navigator.pop(sheetContext);
                                      await _deleteExpense(expense);
                                    },
                                    child: const Text('Xóa'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(sheetContext);
                                },
                                child: const Text('Đóng'),
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
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: scheme.errorContainer,
          child: Icon(icon, color: scheme.error),
        ),
        title: Text(
          expense.category,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${expense.note} • ${expense.date}'),
        trailing: Text(
          '-${formatMoney(expense.amount)}',
          style: TextStyle(color: scheme.error, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
