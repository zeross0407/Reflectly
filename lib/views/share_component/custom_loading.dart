import 'package:flutter/material.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/views/challenge/edit_daily_challenge.dart';

class CustomLoadingDialog extends StatelessWidget {
  final ActionStatus actionStatus;
  final VoidCallback onClose;

  const CustomLoadingDialog({
    Key? key,
    required this.actionStatus,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(actionStatus == ActionStatus.success){
      Future.delayed(Duration(milliseconds: 1000),() {
        onClose();
      },);
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight,
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          height: screenWidth * 0.4,
          width: screenWidth * 0.45,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: is_darkmode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenWidth * 0.05),
                    loading_icon_cycle(actionStatus),
                    SizedBox(height: screenWidth * 0.05),
                    Text(
                      loading_text_cycle(actionStatus),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Second",
                        color: is_darkmode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onClose,
                  child: Icon(
                    Icons.close,
                    color: is_darkmode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
