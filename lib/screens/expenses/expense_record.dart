import 'package:flutter/foundation.dart';

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

  ExpenseRecord copyWith({
    String? category,
    String? note,
    double? amount,
    String? jarName,
  }) {
    return ExpenseRecord(
      id: id,
      category: category ?? this.category,
      note: note ?? this.note,
      amount: amount ?? this.amount,
      date: date,
      jarName: jarName ?? this.jarName,
    );
  }
}

final ValueNotifier<List<ExpenseRecord>> expenseRecords =
    ValueNotifier([
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
]);

List<ExpenseRecord> get demoExpenses => expenseRecords.value;
