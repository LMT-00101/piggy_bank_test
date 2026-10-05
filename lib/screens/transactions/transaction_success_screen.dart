import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    String type = 'deposit';
    double amount = 0;
    String jarName = 'Hũ tiết kiệm';
    String fromJarName = '';

    if (arguments is Map<String, dynamic>) {
      type = arguments['type']?.toString() ?? 'deposit';

      final rawAmount = arguments['amount'];

      if (rawAmount is num) {
        amount = rawAmount.toDouble();
      }

      jarName =
          arguments['jarName']?.toString() ?? 'Hũ tiết kiệm';

      fromJarName =
          arguments['fromJarName']?.toString() ?? '';
    }

    final isWithdraw = type == 'withdraw';
    final isTransfer = type == 'transfer';

    String title;
    String description;
    String amountLabel;

    if (isTransfer) {
      title = 'Chuyển tiền thành công';
      description =
          'Tiền đã được chuyển giữa hai hũ thành công.';
      amountLabel = 'Số tiền chuyển';
    } else if (isWithdraw) {
      title = 'Rút tiền thành công';
      description =
          'Tiền đã được rút khỏi hũ thành công.';
      amountLabel = 'Số tiền rút';
    } else {
      title = 'Nạp tiền thành công';
      description =
          'Tiền đã được nạp vào hũ thành công.';
      amountLabel = 'Số tiền nạp';
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 72,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: amountLabel,
                        value: formatMoney(amount),
                        valueBold: true,
                      ),

                      const Divider(height: 24),

                      if (isTransfer) ...[
                        _InfoRow(
                          label: 'Hũ nguồn',
                          value: fromJarName.isEmpty
                              ? 'Không xác định'
                              : fromJarName,
                        ),
                        const Divider(height: 24),
                      ],

                      _InfoRow(
                        label:
                            isTransfer ? 'Hũ đích' : 'Hũ',
                        value: jarName,
                      ),

                      const Divider(height: 24),

                      _InfoRow(
                        label: 'Trạng thái',
                        value: 'Thành công',
                        valueColor: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Về trang chủ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Quay lại',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: valueBold
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}