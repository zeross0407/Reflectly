import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:myrefectly/views/user/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ColorSelectorScreen_Setting extends StatefulWidget {
  final User_Viewmodel view_model;
  const ColorSelectorScreen_Setting({super.key, required this.view_model});

  @override
  _ColorSelectorScreenState createState() => _ColorSelectorScreenState();
}

class _ColorSelectorScreenState extends State<ColorSelectorScreen_Setting> {
  final PageController _controller =
      PageController(viewportFraction: 0.3, initialPage: theme_selected);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        //margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: all_color[theme_selected],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: my_shadow),
      ),
      Align(
          alignment: Alignment.centerRight,
          child: SvgPicture.asset(
            height: screenWidth_Global * 0.4,
            "assets/ico/wand.svg",
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.03), BlendMode.srcIn),
          )),

      //height: 220,
      PageView.builder(
        controller: _controller,
        itemCount: all_color.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double pageOffset = 0.0;

              if (_controller.hasClients &&
                  _controller.position.haveDimensions) {
                pageOffset = _controller.page! - index;
              } else {
                // Tính toán giá trị khởi tạo dựa trên _currentPage
                pageOffset = theme_selected - index.toDouble();
              }

              // Tính toán tỷ lệ và dịch chuyển
              double scale = 1.0 - (pageOffset.abs() * 0.3);
              double translationY =
                  40 * (1 - scale); // Điều chỉnh dịch chuyển dọc

              scale = scale.clamp(0.8, 1.0);

              return Transform.translate(
                offset: Offset(0, translationY),
                child: Transform.scale(
                  scale: scale - 0.1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        theme_selected = index;
                      });
                      _controller.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.decelerate);
                      theme_selected = index;
                      widget.view_model.user.theme_color = theme_selected;
                      widget.view_model.user.save();
                      Provider.of<Navigation_viewmodel>(context, listen: false)
                          .updateUI();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // Màu của shadow với độ mờ
                            spreadRadius: 3, // Bán kính lan tỏa của shadow
                            blurRadius: 7, // Độ mờ của shadow
                            offset:
                                const Offset(0, 3), // Vị trí của shadow (x, y)
                          ),
                        ],
                        gradient: LinearGradient(
                            colors: all_color[index],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ]);
  }
}
