import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Infinite Time Picker - Material Style"),
        ),
        body: const Center(
          child: InfiniteTimePicker(),
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}

class InfiniteTimePicker extends StatefulWidget {
  const InfiniteTimePicker({super.key});

  @override
  _InfiniteTimePickerState createState() => _InfiniteTimePickerState();
}

class _InfiniteTimePickerState extends State<InfiniteTimePicker> {
  final int _initialHour =
      24 * 100; // Bắt đầu từ giữa danh sách giờ (giả lập vô hạn)
  final int _initialMinute =
      60 * 100; // Bắt đầu từ giữa danh sách phút (giả lập vô hạn)

  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minuteController;

  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _hourController = FixedExtentScrollController(initialItem: _initialHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _initialMinute);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(150.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bộ chọn giờ
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  height: 100,
                  child: Stack(
                    children: [
                      ListWheelScrollView.useDelegate(
                        controller: _hourController,
                        itemExtent: 50.0,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedHour = index % 24; // Giới hạn từ 0 đến 23
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final displayHour = index % 24;
                            return Center(
                              child: Text(
                                displayHour.toString().padLeft(2, '0'),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: selectedHour == index % 24
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.25)),
                              ),
                            );
                          },
                        ),
                      ),
                      //_buildFadingEffect(),
                    ],
                  ),
                ),
              ),
              const Text(
                ":",
                style: TextStyle(fontSize: 24),
              ),
              // Bộ chọn phút
              Expanded(
                child: Container(
                  height: 100,
                  child: Stack(
                    children: [
                      ListWheelScrollView.useDelegate(
                        controller: _minuteController,
                        itemExtent: 50.0,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedMinute = index % 60; // Giới hạn từ 0 đến 59
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final displayMinute = index % 60;
                            return Center(
                              child: Text(
                                displayMinute.toString().padLeft(2, '0'),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: selectedMinute == index % 24
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.25)),
                              ),
                            );
                          },
                        ),
                      ),
                      //_buildFadingEffect(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hourController?.dispose();
    _minuteController?.dispose();
    super.dispose();
  }
}
