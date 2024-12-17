import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/views/statistical/statistical_viewmodel.dart';
import 'statistical_viewmodel_test.mocks.dart';

@GenerateMocks([Repository])
void main() {
  TestWidgetsFlutterBinding
      .ensureInitialized(); // Khởi tạo binding cho môi trường test
  group('Statistical_Viewmodel Tests', () {
    late MockRepository<int, Entry> mockEntryRepo;
    late Statistical_Viewmodel viewModel;

    setUp(() async {
      final tempDir =
          Directory.systemTemp.createTempSync(); // Tạo đường dẫn tạm thời
      Hive.init(tempDir.path); // Khởi tạo Hive với đường dẫn tạm thời

      // Đăng ký các adapter Hive nếu cần
      Hive.registerAdapter(FeelingAdapter());
      Hive.registerAdapter(ActivityAdapter());
      Hive.registerAdapter(EntryAdapter());
      Hive.registerAdapter(MoodCheckinAdapter());

      // Mock repository
      mockEntryRepo = MockRepository<int, Entry>();
      var mockActivityRepo = MockRepository<String, Activity>();
      var mockFeelingRepo = MockRepository<String, Feeling>();

      // Tạo ViewModel
      viewModel = Statistical_Viewmodel(500);
      viewModel
        ..entry_repo = mockEntryRepo
        ..activity_repo = mockActivityRepo
        ..feeling_repo = mockFeelingRepo;
    });

    test('statis_mood_break_down calculates mood breakdown correctly',
        () async {
      // Mock dữ liệu
      List<Entry> entries = [
        MoodCheckin(
          UUID: "123456789",
          title: "",
          description: "",
          mood: 1.0,
          activities: [],
          feelings: [],
          submitTime: DateTime.now(),
        ),
        MoodCheckin(
          UUID: "123456788",
          title: "",
          description: "",
          mood: 2.0,
          activities: [],
          feelings: [],
          submitTime: DateTime.now(),
        ),
        MoodCheckin(
          UUID: "123456787",
          title: "",
          description: "",
          mood: 3.0,
          activities: [],
          feelings: [],
          submitTime: DateTime.now(),
        ),
      ];

      // Giả lập trả về dữ liệu từ repository
      when(mockEntryRepo.getAll()).thenAnswer((_) async => entries);

      // Gọi hàm
      await viewModel.statis_mood_break_down(entries);

      // Kiểm tra kết quả
      expect(viewModel.mood_break_down[1], 1 / 3);
      expect(viewModel.mood_break_down[2], 1 / 3);
      expect(viewModel.mood_break_down[3], 1 / 3);
    });
  });

///////////////////////////////////////////////////////////////////////////

}
