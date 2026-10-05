import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../routes/app_routes.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() =>
      _TransferScreenState();
}

class _TransferScreenState
    extends State<TransferScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String? sourceJarId;
  String? destinationJarId;

  @override
  void initState() {
    super.initState();

    final jars = AppStore.instance.jars;

    if (jars.isNotEmpty) {
      sourceJarId = jars.first.id;
    }

    if (jars.length > 1) {
      destinationJarId = jars[1].id;
    }
  }

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

  String _formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _transfer() {
    final store = AppStore.instance;
    final jars = store.jars;

    if (jars.length < 2) {
      _showMessage(
        'Cần ít nhất 2 hũ để chuyển tiền.',
      );
      return;
    }

    if (sourceJarId == null ||
        destinationJarId == null) {
      _showMessage(
        'Vui lòng chọn hũ nguồn và hũ đích.',
      );
      return;
    }

    if (sourceJarId == destinationJarId) {
      _showMessage(
        'Hũ nguồn và hũ đích không được trùng nhau.',
      );
      return;
    }

    final amount = _parseAmount();

    if (amount == null || amount <= 0) {
      _showMessage(
        'Vui lòng nhập số tiền hợp lệ.',
      );
      return;
    }

    final sourceJar = jars.firstWhere(
      (jar) => jar.id == sourceJarId,
    );

    final destinationJar = jars.firstWhere(
      (jar) => jar.id == destinationJarId,
    );

    if (amount > sourceJar.balance) {
      _showMessage(
        'Số dư của hũ nguồn không đủ.',
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Xác nhận chuyển tiền',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Từ: ${sourceJar.name}',
              ),
              const SizedBox(height: 6),
              Text(
                'Đến: ${destinationJar.name}',
              ),
              const SizedBox(height: 6),
              Text(
                'Số tiền: ${_formatMoney(amount)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (noteController.text
                  .trim()
                  .isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Ghi chú: ${noteController.text.trim()}',
                ),
              ],
            ],
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
                _confirmTransfer(
                  sourceJar,
                  destinationJar,
                  amount,
                );
              },
              child: const Text(
                'Xác nhận chuyển',
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmTransfer(
    dynamic sourceJar,
    dynamic destinationJar,
    double amount,
  ) {
    sourceJar.balance -= amount;
    destinationJar.balance += amount;

    if (mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.transactionSuccess,
        arguments: {
          'type': 'transfer',
          'amount': amount,
          'source': sourceJar.name,
          'destination': destinationJar.name,
          'note': noteController.text.trim(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jars = AppStore.instance.jars;

    if (jars.length < 2) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chuyển tiền giữa các hũ',
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_horiz,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cần ít nhất 2 hũ để thực hiện chuyển tiền.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.createJar,
                    );
                  },
                  child: const Text(
                    'Tạo hũ mới',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final sourceJar = jars.firstWhere(
      (jar) => jar.id == sourceJarId,
      orElse: () => jars.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chuyển tiền giữa các hũ',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.swap_horiz,
                    size: 36,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Chuyển tiền nội bộ giữa các hũ tiết kiệm',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Hũ nguồn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: sourceJarId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon:
                  Icon(Icons.upload_outlined),
            ),
            items: jars.map(
              (jar) {
                return DropdownMenuItem<String>(
                  value: jar.id,
                  child: Text(
                    '${jar.name} • ${_formatMoney(jar.balance)}',
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                sourceJarId = value;
              });

              if (value == destinationJarId) {
                final alternative = jars
                    .where(
                      (jar) => jar.id != value,
                    )
                    .first;

                setState(() {
                  destinationJarId =
                      alternative.id;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Hũ đích',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: destinationJarId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon:
                  Icon(Icons.download_outlined),
            ),
            items: jars.map(
              (jar) {
                return DropdownMenuItem<String>(
                  value: jar.id,
                  child: Text(jar.name),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                destinationJarId = value;
              });
            },
          ),

          const SizedBox(height: 20),

          Text(
            'Số dư hũ nguồn: ${_formatMoney(sourceJar.balance)}',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: amountController,
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Số tiền chuyển (VNĐ)',
              hintText: 'Nhập số tiền',
              prefixIcon:
                  Icon(Icons.payments_outlined),
              border: OutlineInputBorder(),
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
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _transfer,
              icon: const Icon(
                Icons.swap_horiz,
              ),
              label: const Text(
                'Chuyển tiền',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}