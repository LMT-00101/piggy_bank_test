import 'package:flutter/material.dart';

import '../../data/app_store.dart';

class EditJarScreen extends StatefulWidget {
  const EditJarScreen({super.key});

  @override
  State<EditJarScreen> createState() =>
      _EditJarScreenState();
}

class _EditJarScreenState
    extends State<EditJarScreen> {
  late final TextEditingController nameController;
  late final TextEditingController allocationController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    final jar = AppStore.instance.selectedJar;

    nameController = TextEditingController(
      text: jar?.name ?? '',
    );

    allocationController = TextEditingController(
      text: jar?.targetAllocation.toString() ?? '10',
    );

    descriptionController = TextEditingController(
      text: jar?.description ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    allocationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void save() {
    final jar = AppStore.instance.selectedJar;

    if (jar == null) {
      Navigator.pop(context);
      return;
    }

    AppStore.instance.updateJar(
      id: jar.id,
      name: nameController.text.trim(),
      allocation:
          int.tryParse(allocationController.text) ??
              jar.targetAllocation,
      description:
          descriptionController.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hũ'),
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
              labelText: 'Mô tả',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: save,
              child: const Text('Lưu thay đổi'),
            ),
          ),
        ],
      ),
    );
  }
}