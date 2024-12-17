import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/views/statistical/statistical_viewmodel.dart';

import '../../statistical_viewmodel_test.mocks.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockRepository<int, Entry> mockEntryRepo;
  late Statistical_Viewmodel statistical_viewmodel;

  setUp(() async {
    // Tạo thư mục tạm cho Hive
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);

    // Kiểm tra và chỉ đăng ký adapter nếu chưa được đăng ký
    if (!Hive.isAdapterRegistered(EntryAdapter().typeId)) {
      Hive.registerAdapter(EntryAdapter());
    }
    if (!Hive.isAdapterRegistered(FeelingAdapter().typeId)) {
      Hive.registerAdapter(FeelingAdapter());
    }
    if (!Hive.isAdapterRegistered(ActivityAdapter().typeId)) {
      Hive.registerAdapter(ActivityAdapter());
    }
    if (!Hive.isAdapterRegistered(MoodCheckinAdapter().typeId)) {
      Hive.registerAdapter(MoodCheckinAdapter());
    }

    // Mock repository
    mockEntryRepo = MockRepository<int, Entry>();
    var mockActivityRepo = MockRepository<String, Activity>();
    var mockFeelingRepo = MockRepository<String, Feeling>();

    statistical_viewmodel = Statistical_Viewmodel(500);
    statistical_viewmodel
      ..entry_repo = mockEntryRepo
      ..activity_repo = mockActivityRepo
      ..feeling_repo = mockFeelingRepo;
  });

  group('groupEntriesByDate', () {
    tearDown(() async {
      // Dọn dẹp sau mỗi test
      await Hive.close();
    });

    test('returns empty list when input is empty', () {
      final result = statistical_viewmodel.groupEntriesByDate([]);
      expect(result, []);
    });

    test('groups entries with the same date', () {
      try {
        final date = DateTime(2024, 12, 5);
        final entries = [
          Entry(UUID: '1', submitTime: date),
          Entry(UUID: '2', submitTime: date),
        ];

        final result = statistical_viewmodel.groupEntriesByDate(entries);

        expect(result.length, 1);
        expect(result[0].length, 2);
        expect(result[0][0].submitTime, date);
      } catch (e, stack) {
        fail('Test failed with error: $e\nStack trace: $stack');
      }
    });

    test('groups entries into different dates', () {
      final entries = [
        Entry(UUID: '1', submitTime: DateTime(2024, 12, 5)),
        Entry(UUID: '2', submitTime: DateTime(2024, 12, 6)),
        Entry(UUID: '3', submitTime: DateTime(2024, 12, 5)),
      ];

      final result = statistical_viewmodel.groupEntriesByDate(entries);

      expect(result.length, 2); // 2 nhóm khác nhau
      expect(result.any((group) => group.length == 2),
          true); // Nhóm đầu có 2 phần tử
      expect(result.any((group) => group.length == 1),
          true); // Nhóm sau có 1 phần tử
    });

    test('maintains order of entries within the same group', () {
      final entries = [
        Entry(UUID: '1', submitTime: DateTime(2024, 12, 5, 10, 0)),
        Entry(UUID: '2', submitTime: DateTime(2024, 12, 5, 11, 0)),
      ];

      final result = statistical_viewmodel.groupEntriesByDate(entries);

      expect(result.length, 1);
      expect(result[0][0].UUID, '1');
      expect(result[0][1].UUID, '2');
    });

    test('handles entries with edge case dates', () {
      final entries = [
        Entry(UUID: '1', submitTime: DateTime(2024, 12, 31, 23, 59)),
        Entry(UUID: '2', submitTime: DateTime(2025, 1, 1, 0, 1)),
      ];

      final result = statistical_viewmodel.groupEntriesByDate(entries);

      expect(result.length, 2);
      expect(result[0][0].submitTime.year, 2024);
      expect(result[1][0].submitTime.year, 2025);
    });
  });

/////////////////////////////////////////////////////////////////////////////////////////////////

  group('statis_mood', () {
    late Statistical_Viewmodel statistical_viewmodel;

    setUp(() {
      statistical_viewmodel = Statistical_Viewmodel(500);
    });

    test('should correctly calculate average mood and group data by date',
        () async {
      // Create mock MoodCheckin data
      final entries = [
        MoodCheckin(
          UUID: '1',
          submitTime: DateTime(2024, 12, 5, 10, 0),
          title: 'Check-in 1',
          mood: 3.0,
          activities: ['Exercise'],
          feelings: ['Happy'],
        ),
        MoodCheckin(
          UUID: '2',
          submitTime: DateTime(2024, 12, 5, 11, 0),
          title: 'Check-in 2',
          mood: 4.0,
          activities: ['Reading'],
          feelings: ['Calm'],
        ),
        MoodCheckin(
          UUID: '3',
          submitTime: DateTime(2024, 12, 6, 10, 0),
          title: 'Check-in 3',
          mood: 2.0,
          activities: ['Work'],
          feelings: ['Stressed'],
        ),
        MoodCheckin(
          UUID: '4',
          submitTime: DateTime(2024, 12, 6, 11, 0),
          title: 'Check-in 4',
          mood: 5.0,
          activities: ['Meditation'],
          feelings: ['Relaxed'],
        ),
      ];

      // Call the function to be tested
      await statistical_viewmodel.statis_mood(entries);

      // Check that average mood is correctly calculated
      final expectedAverageMood = (3.0 + 4.0 + 2.0 + 5.0) / 4;
      expect(statistical_viewmodel.average_mood, expectedAverageMood);

      // Check that current_data has the expected number of entries
      expect(statistical_viewmodel.current_data.length, 2);

      // Check that current_data_time contains the correct date
      expect(statistical_viewmodel.current_data_time.length, 2);
      expect(statistical_viewmodel.current_data_time[0], DateTime(2024, 12, 5));
      expect(statistical_viewmodel.current_data_time[1], DateTime(2024, 12, 6));

      // Check that the current_data is sorted by day and that the offset values are calculated correctly
      expect(statistical_viewmodel.current_data[0].dx,
          lessThan(statistical_viewmodel.current_data[1].dx));
    });

    test('should handle empty list of entries correctly', () async {
      final entries = <Entry>[];

      await statistical_viewmodel.statis_mood(entries);

      expect(statistical_viewmodel.average_mood, 0);
      expect(statistical_viewmodel.current_data.isEmpty, true);
      expect(statistical_viewmodel.current_data_time.isEmpty, true);
    });

    test('should correctly group entries by date', () async {
      // Create mock data
      final entries = [
        MoodCheckin(
          UUID: '1',
          submitTime: DateTime(2024, 12, 5, 10, 0),
          title: 'Check-in 1',
          mood: 3.0,
          activities: ['Exercise'],
          feelings: ['Happy'],
        ),
        MoodCheckin(
          UUID: '2',
          submitTime: DateTime(2024, 12, 5, 11, 0),
          title: 'Check-in 2',
          mood: 4.0,
          activities: ['Reading'],
          feelings: ['Calm'],
        ),
        MoodCheckin(
          UUID: '3',
          submitTime: DateTime(2024, 12, 6, 10, 0),
          title: 'Check-in 3',
          mood: 2.0,
          activities: ['Work'],
          feelings: ['Stressed'],
        ),
      ];

      // Call the function to be tested
      await statistical_viewmodel.statis_mood(entries);

      // Verify that entries are grouped by date
      expect(statistical_viewmodel.current_data.length,
          2); // 2 groups: one for Dec 5, one for Dec 6
    });

    test('should correctly calculate mood averages per day', () async {
      // Create mock data
      final entries = [
        MoodCheckin(
          UUID: '1',
          submitTime: DateTime(2024, 12, 5, 10, 0),
          title: 'Check-in 1',
          mood: 2.0,
          activities: ['Exercise'],
          feelings: ['Happy'],
        ),
        MoodCheckin(
          UUID: '2',
          submitTime: DateTime(2024, 12, 5, 11, 0),
          title: 'Check-in 2',
          mood: 4.0,
          activities: ['Reading'],
          feelings: ['Calm'],
        ),
        MoodCheckin(
          UUID: '3',
          submitTime: DateTime(2024, 12, 6, 10, 0),
          title: 'Check-in 3',
          mood: 3.0,
          activities: ['Work'],
          feelings: ['Stressed'],
        ),
      ];

      // Call the function to be tested
      await statistical_viewmodel.statis_mood(entries);

      // Verify average mood for Dec 5
      expect(statistical_viewmodel.current_data[0].dy,
          closeTo(0.65 * (1 - (3.0 / 4)), 0.01));
    });
  });
}
