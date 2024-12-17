import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';

class View_Photo extends StatefulWidget {
  final List<Uint8List> photo_data;

  View_Photo({super.key, required this.photo_data});

  @override
  _View_PhotoState createState() => _View_PhotoState();
}

class _View_PhotoState extends State<View_Photo> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 0.85, initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: is_darkmode ? background_dark : background_light,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenWidth * 0.15, right: screenWidth * 0.05),
              child: exit_button(context, is_darkmode),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: screenWidth * 0.15),
              height: screenHeight * 0.75,
              child: PageView.builder(
                controller: controller,
                itemCount: widget.photo_data.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      double pageOffset = 0.0;

                      if (controller.hasClients &&
                          controller.position.haveDimensions) {
                        pageOffset = controller.page! - index;
                      } else {
                        pageOffset = theme_selected - index.toDouble();
                      }

                      // Tính toán tỷ lệ và dịch chuyển
                      double scale = 1.0 - (pageOffset.abs() * 0.3);
                      double translationY =
                          40 * (1 - scale); // Điều chỉnh dịch chuyển dọc

                      scale = scale.clamp(0.9, 1.0);

                      return Transform.translate(
                        offset: Offset(0, translationY),
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            margin: EdgeInsets.only(bottom: screenWidth * 0.05),
                            decoration: BoxDecoration(boxShadow: my_shadow),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.memory(
                                widget.photo_data[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
