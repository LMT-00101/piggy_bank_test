import '../models/jar.dart';

class AppStore {
  AppStore._();

  static final AppStore instance = AppStore._();

  final List<Jar> jars = [
    Jar(
      id: 'jar_1',
      name: 'Quỹ khẩn cấp',
      icon: 'savings',
      targetAllocation: 20,
      description: 'Khoản dự phòng cho các tình huống khẩn cấp.',
      status: 'Đang hoạt động',
      balance: 12500000,
    ),
    Jar(
      id: 'jar_2',
      name: 'Du lịch',
      icon: 'flight',
      targetAllocation: 10,
      description: 'Tiết kiệm cho những chuyến du lịch.',
      status: 'Đang hoạt động',
      balance: 5500000,
    ),
    Jar(
      id: 'jar_3',
      name: 'Mua laptop',
      icon: 'laptop',
      targetAllocation: 15,
      description: 'Mục tiêu mua laptop mới.',
      status: 'Đang hoạt động',
      balance: 7200000,
    ),
    Jar(
      id: 'jar_4',
      name: 'Học tập',
      icon: 'school',
      targetAllocation: 10,
      description: 'Chi phí học tập và phát triển bản thân.',
      status: 'Đang hoạt động',
      balance: 3500000,
    ),
  ];

  String? selectedJarId;

  double currentSpentMonth = 4250000;

  double get totalSavings {
    return jars.fold(
      0,
      (total, jar) => total + jar.balance,
    );
  }

  Jar? get selectedJar {
    if (selectedJarId == null) return null;

    for (final jar in jars) {
      if (jar.id == selectedJarId) {
        return jar;
      }
    }

    return null;
  }

  void addJar({
    required String name,
    required int allocation,
    required String description,
  }) {
    jars.add(
      Jar(
        id: 'jar_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        icon: 'savings',
        targetAllocation: allocation,
        description: description,
        status: 'Đang hoạt động',
        balance: 0,
      ),
    );
  }

  void updateJar({
    required String id,
    required String name,
    required int allocation,
    required String description,
  }) {
    final jar = jars.firstWhere(
      (item) => item.id == id,
    );

    jar.name = name;
    jar.targetAllocation = allocation;
    jar.description = description;
  }

  void deleteJar(String id) {
    jars.removeWhere(
      (jar) => jar.id == id,
    );

    if (selectedJarId == id) {
      selectedJarId = null;
    }
  }
}