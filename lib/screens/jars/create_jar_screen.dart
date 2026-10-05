import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../routes/app_routes.dart';

class CreateJarScreen extends StatefulWidget {
  const CreateJarScreen({super.key});

  @override
  State<CreateJarScreen> createState() =>
      _CreateJarScreenState();
}

class _CreateJarScreenState
    extends State<CreateJarScreen> {
  final nameController = TextEditingController();
  final allocationController =
      TextEditingController(text: '10');
  final descriptionController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    allocationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void createJar() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên hũ.'),
        ),
      );
      return;
    }

    AppStore.instance.addJar(
      name: name,
      allocation:
          int.tryParse(allocationController.text) ?? 10,
      description:
          descriptionController.text.trim(),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.jars,
      (route) => route.settings.name == AppRoutes.home ||
          route.settings.name == AppRoutes.jars,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo hũ tiết kiệm mới'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Tên hũ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: allocationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Tỷ lệ phân bổ (%)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Mô tả / Mục đích',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: createJar,
              child: const Text('Tạo hũ'),
            ),
          ),
        ],
      ),
    );
  }
}