import 'package:flutter/material.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/viewmodels/categories_viewmodel.dart';
import 'package:myrefectly/views/quotes/scaleable_icon.dart';

class CategoryCard extends StatefulWidget {
  final Categories_Viewmodel view_model;
  final int index;
  final String name;
  final String image;

  CategoryCard(
      {required this.view_model,
      required this.index,
      required this.name,
      required this.image});
  @override
  State<StatefulWidget> createState() => CategoryCard_State();
}

class CategoryCard_State extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      decoration: BoxDecoration(boxShadow: my_shadow),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  screenWidth * 0.02,
                ),
                gradient: LinearGradient(
                    colors:
                        widget.view_model.user.quote_category == widget.index
                            ? all_color[theme_selected]
                            : [card_normal(), card_normal()],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)),
          ),
          Positioned(
            //alignment: Alignment.bottomRight,
            bottom: -screenWidth * 0.05,
            right: -screenWidth * 0.05,
            child: ClipOval(
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
                width: screenWidth * 0.225,
                height: screenWidth * 0.225,
              ),
            ),
          ),
          if (widget.view_model.user.quote_category == widget.index)
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenWidth * 0.02,
                      right: screenWidth * 0.02,
                    ),
                    child: ScalableIconWidget(
                      iconColor: all_color[theme_selected][0],
                      screenWidth: screenWidth,
                    ),
                  ),
                )),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.all(screenWidth * 0.05),
              child: Text(
                widget.name,
                style: TextStyle(
                    color: is_darkmode ||
                            widget.view_model.user.quote_category ==
                                widget.index
                        ? Colors.white.withOpacity(0.75)
                        : Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
