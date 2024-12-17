import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myrefectly/share/button.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  group('CustomButton Tests', () {
    late MockCallback onTapMock;
    late MockCallback onLongPressMock;
    late MockCallback onLongPressStartMock;
    late MockCallback onLongPressEndMock;

    setUp(() {
      onTapMock = MockCallback();
      onLongPressMock = MockCallback();
      onLongPressStartMock = MockCallback();
      onLongPressEndMock = MockCallback();
    });

    testWidgets('Test onTap callback', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: CustomButton(
            onTap: onTapMock,
            color: Colors.blue,
            color_text: Colors.white,
            have_shadow: false,
            text: 'Tap Me',
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      // Assert
      verify(onTapMock()).called(1);
    });

    testWidgets('Test onLongPress callback', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: CustomButton(
            onLongPress: onLongPressMock,
            color: Colors.blue,
            color_text: Colors.white,
            have_shadow: false,
            text: 'Long Press Me',
          ),
        ),
      );

      // Act
      await tester.longPress(find.text('Long Press Me'));
      await tester.pumpAndSettle();

      // Assert
      verify(onLongPressMock()).called(1);
    });

    testWidgets('Test scale effect on long press', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: CustomButton(
            color: Colors.blue,
            color_text: Colors.white,
            have_shadow: true,
            text: 'Press',
          ),
        ),
      );

      // Act
      final Finder button = find.text('Press');
      await tester.longPress(button);
      //await tester.pump();

      // Assert
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        0.9,
      );

      // Release long press
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        1.0,
      );
    });

    testWidgets('Test button renders with icon and text',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: CustomButton(
            color: Colors.blue,
            color_text: Colors.white,
            have_shadow: false,
            text: 'Icon Test',
            icon: 'assets/all/(1).svg', // Đường dẫn SVG icon
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Icon Test'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('Test button without shadow', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: CustomButton(
            color: Colors.blue,
            color_text: Colors.white,
            have_shadow: false,
            text: 'No Shadow',
          ),
        ),
      );

      // Act & Assert
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, isEmpty);
    });
  });

  testWidgets('CustomButton should display text when provided',
      (WidgetTester tester) async {
    // Build widget with text
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomButton(
          text: 'Click Me',
          color: Colors.blue,
          color_text: Colors.white,
          have_shadow: true,
        ),
      ),
    ));

    // Verify that the text "Click Me" is displayed
    expect(find.text('Click Me'), findsOneWidget);
  });

  testWidgets('CustomButton should trigger onTap callback when tapped',
      (WidgetTester tester) async {
    // Define the onTap callback
    bool wasTapped = false;
    void onTap() {
      wasTapped = true;
    }

    // Build widget with onTap callback
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomButton(
          text: 'Click Me',
          color: Colors.blue,
          color_text: Colors.white,
          have_shadow: true,
          onTap: onTap,
        ),
      ),
    ));

    // Simulate tap on the button
    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    // Verify that the onTap callback was triggered
    expect(wasTapped, true);
  });

  testWidgets('CustomButton should update scale on long press',
      (WidgetTester tester) async {
    // Define the onLongPress callback
    bool wasLongPressed = false;

    // Build widget with onLongPress callback
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomButton(
          text: 'Long Press Me',
          color: Colors.green,
          color_text: Colors.white,
          have_shadow: true,
          onLongPress: () {
            wasLongPressed = true;
          },
        ),
      ),
    ));

    // Simulate long press on the button
    await tester.longPress(find.byType(CustomButton));
    await tester.pumpAndSettle();

    // Verify that the onLongPress callback was triggered
    expect(wasLongPressed, true);
  });

  testWidgets('CustomButton should show icon when provided',
      (WidgetTester tester) async {
    // Build widget with icon
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomButton(
          icon: 'assets/all/(2).svg',
          color: Colors.blue,
          color_text: Colors.white,
          have_shadow: true,
        ),
      ),
    ));

    // Verify that the icon is displayed
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets(
      'CustomButton should show scaled effect when pressed and reset on long press end',
      (WidgetTester tester) async {
    // Bước 1: Xây dựng widget
    await tester.pumpWidget(MaterialApp(
      home: CustomButton(
        color: Colors.blue,
        color_text: Colors.white,
        have_shadow: true,
        text: 'Press me',
      ),
    ));

    // Bước 2: Mô phỏng long press
    await tester.longPress(find.byType(CustomButton));

    // Bước 4: Kiểm tra giá trị scale sau khi long press
    final animatedScale =
        tester.widget<AnimatedScale>(find.byType(AnimatedScale));
    expect(animatedScale.scale,
        0.9); // Kiểm tra xem scale có phải là 0.9 khi long press
  });
}
