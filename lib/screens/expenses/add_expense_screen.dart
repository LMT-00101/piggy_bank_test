import 'package:flutter/material.dart';

import 'expense_record.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseRecord? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String category = 'Ăn uống';
  String selectedJar = 'Chi tiêu hàng ngày';

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    if (expense != null) {
      amountController.text =
          expense.amount.toStringAsFixed(0);
      noteController.text = expense.note;
      category = expense.category;
      selectedJar = expense.jarName;
    }
  }

  final categories = const [
    'Ăn uống',
    'Mua sắm',
    'Hóa đơn',
    'Giải trí',
    'Khác',
  ];

  final jars = const [
    'Chi tiêu hàng ngày',
    'Giải trí',
    'Mua sắm',
  ];

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  double? _parseAmount() {
    return double.tryParse(
      amountController.text
          .trim()
          .replaceAll('.', '')
          .replaceAll(',', ''),
    );
  }

  void _saveExpense() {
    final amount = _parseAmount();

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập số tiền hợp lệ.',
          ),
        ),
      );
      return;
    }

    if (amount > 3000000) {
      _showLimitWarning(amount);
      return;
    }

    _saveExpenseRecord(amount);
  }

  void _saveExpenseRecord(double amount) {
    final expense = widget.expense;
    if (expense == null) {
      expenseRecords.value = [
        ExpenseRecord(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        category: category,
        note: noteController.text.trim(),
        amount: amount,
        date: 'Hôm nay',
        jarName: selectedJar,
        ),
        ...expenseRecords.value,
      ];
    } else {
      expenseRecords.value = expenseRecords.value
          .map(
            (item) => item.id == expense.id
                ? item.copyWith(
                    category: category,
                    note: noteController.text.trim(),
                    amount: amount,
                    jarName: selectedJar,
                  )
                : item,
          )
          .toList();
    }

    Navigator.pop(context, true);
  }

  void _showLimitWarning(double amount) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Cảnh báo vượt hạn mức',
          ),
          content: const Text(
            'Khoản chi này có thể khiến bạn vượt quá hạn mức tuần/tháng đã thiết lập. Bạn có muốn tiếp tục?',
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
                _saveExpenseRecord(amount);
              },
              child: const Text(
                'Vẫn ghi nhận',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null
              ? 'Thêm khoản chi'
              : 'Sửa khoản chi',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: amountController,
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              labelText:
                  'Số tiền chi tiêu (VNĐ)',
              hintText: 'Ví dụ: 150000',
              prefixIcon:
                  Icon(Icons.payments_outlined),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Danh mục',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map(
              (item) {
                return ChoiceChip(
                  label: Text(item),
                  selected: category == item,
                  onSelected: (_) {
                    setState(() {
                      category = item;
                    });
                  },
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 24),

          const Text(
            'Hũ trích tiền',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: RadioGroup<String>(
              groupValue: selectedJar,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedJar = value;
                });
              },
              child: Column(
                children: jars.map(
                  (jar) {
                    return RadioListTile<String>(
                      value: jar,
                      title: Text(jar),
                    );
                  },
                ).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Ghi chú',
              hintText:
                  'Nhập ghi chú nếu cần',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _saveExpense,
              child: const Text(
                'Lưu khoản chi',
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