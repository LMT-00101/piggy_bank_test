import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../routes/app_routes.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final amountController = TextEditingController();

  String selectedAccount = 'Vietcombank •••• 8888';

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void deposit() {
    final amount = double.tryParse(
      amountController.text.replaceAll('.', '').replaceAll(',', ''),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ.'),
        ),
      );
      return;
    }

    final jar = AppStore.instance.selectedJar;

    if (jar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chưa chọn hũ tiết kiệm.'),
        ),
      );
      return;
    }

    setState(() {
      jar.balance += amount;
    });

    Navigator.pushNamed(
      context,
      AppRoutes.transactionSuccess,
      arguments: {
        'type': 'deposit',
        'amount': amount,
        'jarName': jar.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jar = AppStore.instance.selectedJar;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nạp tiền vào hũ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (jar != null)
            Card(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .primary,
                      child: const Icon(
                        Icons.savings,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hũ nhận tiền',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            jar.name,
                            style: const TextStyle(
                              fontSize: 17,
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

          const SizedBox(height: 24),

          const Text(
            'Tài khoản nguồn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: selectedAccount,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Vietcombank •••• 8888',
                child: Text('Vietcombank •••• 8888'),
              ),
              DropdownMenuItem(
                value: 'MB Bank •••• 1234',
                child: Text('MB Bank •••• 1234'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedAccount = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Số tiền',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Nhập số tiền',
              suffixText: 'đ',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              _AmountChip(
                amount: 100000,
                onSelected: () {
                  amountController.text = '100000';
                },
              ),
              _AmountChip(
                amount: 500000,
                onSelected: () {
                  amountController.text = '500000';
                },
              ),
              _AmountChip(
                amount: 1000000,
                onSelected: () {
                  amountController.text = '1000000';
                },
              ),
              _AmountChip(
                amount: 2000000,
                onSelected: () {
                  amountController.text = '2000000';
                },
              ),
            ],
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: deposit,
              child: const Text(
                'Xác nhận nạp tiền',
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

class _AmountChip extends StatelessWidget {
  final double amount;
  final VoidCallback onSelected;

  const _AmountChip({
    required this.amount,
    required this.onSelected,
  });

  String formatAmount() {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text('${formatAmount()} đ'),
      onPressed: onSelected,
    );
  }
}