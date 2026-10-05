import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../routes/app_routes.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() =>
      _WithdrawScreenState();
}

class _WithdrawScreenState
    extends State<WithdrawScreen> {
  final amountController = TextEditingController();

  String? selectedJarId;
  String selectedBank = 'Vietcombank';
  String selectedAccount = '***8888';

  final List<Map<String, String>> bankAccounts = [
    {
      'bank': 'Vietcombank',
      'account': '***8888',
    },
    {
      'bank': 'MB Bank',
      'account': '***6688',
    },
    {
      'bank': 'BIDV',
      'account': '***1234',
    },
  ];

  @override
  void initState() {
    super.initState();

    final store = AppStore.instance;

    if (store.jars.isNotEmpty) {
      selectedJarId =
          store.selectedJarId ?? store.jars.first.id;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  double? _parseAmount() {
    final text = amountController.text
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '');

    return double.tryParse(text);
  }

  String _formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )} đ';
  }

  String get destination {
    return '$selectedBank $selectedAccount';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _requestWithdraw() {
    final store = AppStore.instance;

    if (store.jars.isEmpty) {
      _showMessage(
        'Bạn chưa có hũ tiết kiệm.',
      );
      return;
    }

    if (selectedJarId == null) {
      _showMessage(
        'Vui lòng chọn hũ để rút tiền.',
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

    final jar = store.jars.firstWhere(
      (item) => item.id == selectedJarId,
    );

    if (amount > jar.balance) {
      _showMessage(
        'Số dư trong hũ không đủ để thực hiện giao dịch.',
      );
      return;
    }

    _showWithdrawConfirmation(
      jar.name,
      jar.balance,
      amount,
    );
  }

  void _showWithdrawConfirmation(
    String jarName,
    double currentBalance,
    double amount,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Xác nhận rút tiền',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin giao dịch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _ConfirmationRow(
                label: 'Hũ nguồn',
                value: jarName,
              ),
              const SizedBox(height: 10),
              _ConfirmationRow(
                label: 'Tài khoản nhận',
                value: destination,
              ),
              const SizedBox(height: 10),
              _ConfirmationRow(
                label: 'Số tiền rút',
                value: _formatMoney(amount),
              ),
              const SizedBox(height: 10),
              _ConfirmationRow(
                label: 'Số dư sau khi rút',
                value: _formatMoney(
                  currentBalance - amount,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bạn có chắc chắn muốn thực hiện giao dịch này không?',
              ),
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
                _confirmWithdraw(amount);
              },
              child: const Text(
                'Xác nhận rút',
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmWithdraw(double amount) {
    final store = AppStore.instance;

    if (selectedJarId == null) {
      return;
    }

    final jar = store.jars.firstWhere(
      (item) => item.id == selectedJarId,
    );

    if (amount > jar.balance) {
      _showMessage(
        'Số dư trong hũ không đủ để thực hiện giao dịch.',
      );
      return;
    }

    setState(() {
      jar.balance -= amount;
      store.selectedJarId = jar.id;
    });

    Navigator.pushNamed(
      context,
      AppRoutes.transactionSuccess,
      arguments: {
        'type': 'withdraw',
        'amount': amount,
        'jarName': jar.name,
        'destination': destination,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final jars = store.jars;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rút tiền từ hũ',
        ),
      ),
      body: jars.isEmpty
          ? _buildEmptyState(context)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeaderCard(context),

                const SizedBox(height: 24),

                const Text(
                  'Chọn hũ nguồn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                RadioGroup<String>(
                  groupValue: selectedJarId,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedJarId = value;
                    });
                  },
                  child: Column(
                    children: jars.map(
                      (jar) {
                        final isSelected =
                            selectedJarId == jar.id;

                        return Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: RadioListTile<String>(
                            value: jar.id,
                            title: Text(
                              jar.name,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Số dư: ${_formatMoney(jar.balance)}',
                            ),
                            secondary: Icon(
                              Icons.savings_outlined,
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                  : null,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                _buildSelectedJarBalance(),

                const SizedBox(height: 24),

                const Text(
                  'Tài khoản ngân hàng nhận tiền',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                RadioGroup<String>(
                  groupValue:
                      '$selectedBank|$selectedAccount',
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    final parts =
                        value.split('|');

                    if (parts.length != 2) {
                      return;
                    }

                    setState(() {
                      selectedBank = parts[0];
                      selectedAccount = parts[1];
                    });
                  },
                  child: Column(
                    children: bankAccounts.map(
                      (account) {
                        final bank =
                            account['bank']!;
                        final accountNumber =
                            account['account']!;

                        final value =
                            '$bank|$accountNumber';

                        final isSelected =
                            selectedBank == bank &&
                                selectedAccount ==
                                    accountNumber;

                        return Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: RadioListTile<String>(
                            value: value,
                            title: Text(
                              bank,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            subtitle:
                                Text(accountNumber),
                            secondary: Icon(
                              isSelected
                                  ? Icons
                                      .account_balance
                                  : Icons
                                      .account_balance_outlined,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Số tiền rút',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: amountController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Số tiền rút (VNĐ)',
                    hintText:
                        'Ví dụ: 500000',
                    prefixIcon: Icon(
                      Icons.payments_outlined,
                    ),
                    border:
                        OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 12),

                _buildAmountSummary(),

                const SizedBox(height: 28),

                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed:
                        _requestWithdraw,
                    icon: const Icon(
                      Icons.account_balance,
                    ),
                    label: const Text(
                      'Thực hiện rút tiền',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Tiền sẽ được chuyển về tài khoản ngân hàng đã chọn sau khi xác nhận giao dịch.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
  ) {
    return Card(
      color: Theme.of(context)
          .colorScheme
          .primaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              child: Icon(
                Icons.account_balance,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rút tiền về ngân hàng',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Chọn hũ, tài khoản nhận và số tiền cần rút.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedJarBalance() {
    final store = AppStore.instance;

    if (selectedJarId == null ||
        store.jars.isEmpty) {
      return const SizedBox.shrink();
    }

    final jar = store.jars.firstWhere(
      (item) => item.id == selectedJarId,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Số dư có thể rút',
            ),
          ),
          Text(
            _formatMoney(jar.balance),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSummary() {
    final amount = _parseAmount();

    if (amount == null || amount <= 0) {
      return const SizedBox.shrink();
    }

    final store = AppStore.instance;

    if (selectedJarId == null) {
      return const SizedBox.shrink();
    }

    final jar = store.jars.firstWhere(
      (item) => item.id == selectedJarId,
    );

    final isEnough = amount <= jar.balance;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12),
        color: isEnough
            ? Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
            : Theme.of(context)
                .colorScheme
                .errorContainer,
      ),
      child: Row(
        children: [
          Icon(
            isEnough
                ? Icons.check_circle_outline
                : Icons.error_outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEnough
                  ? 'Số dư sau khi rút: ${_formatMoney(jar.balance - amount)}'
                  : 'Số tiền rút vượt quá số dư của hũ.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bạn chưa có hũ tiết kiệm.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy tạo hũ trước khi thực hiện rút tiền.',
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
    );
  }
}

class _ConfirmationRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmationRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}