import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/delay_animation.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/notification/vip.dart';

Widget reflectly_face(BuildContext context) {
  double screenWidth = MediaQuery.sizeOf(context).width;
  return GestureDetector(
    onTap: () {
      // NotificationService.showInstantNotification(
      //               "Instant Notification", "This shows an instant notifications");

      try {
        DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 5));
        NotificationService.scheduleNotification(
          110,
          "Scheduled Notification",
          "This notification is scheduled to appear after 5 seconds",
          scheduledDate,
        );
      } catch (e) {
        print(e);
      }
    },
    child: Container(
      //margin: EdgeInsets.only(top: screenWidth * 0.05),
      height: screenWidth * 0.3,
      width: screenWidth * 0.3,
      child: Stack(alignment: Alignment.center, children: [
        SpreadOutEffect(),
        SizedBox(
          height: screenWidth * 0.3,
          width: screenWidth * 0.16,
          child: DelayAnimation(
            delay: 0,
            shouldFaded: false,
            sliding: false,
            is_faded_animation: false,
            child: FlareActor(
              "assets/all/reflectly_head_expressions.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "look_down_excited",
            ),
          ),
        )
      ]),
    ),
  );
}
