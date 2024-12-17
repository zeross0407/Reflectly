import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/delay_animation.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/notification/vip.dart';
import 'package:myrefectly/repository/repository.dart';

// Widget reflectly_face(BuildContext context) {
//   double screenWidth = MediaQuery.sizeOf(context).width;
//   return GestureDetector(
//     onTap: () {
//       // NotificationService.showInstantNotification(
//       //               "Instant Notification", "This shows an instant notifications");
//       try {
//         DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 5));
//         NotificationService.scheduleNotification(
//           110,
//           "Scheduled Notification",
//           "This notification is scheduled to appear after 5 seconds",
//           scheduledDate,
//         );
//       } catch (e) {
//         print(e);
//       }
//     },
//     child: Container(
//       //margin: EdgeInsets.only(top: screenWidth * 0.05),
//       height: screenWidth * 0.3,
//       width: screenWidth * 0.3,
//       child: Stack(alignment: Alignment.center, children: [
//         SpreadOutEffect(),
//         SizedBox(
//           height: screenWidth * 0.3,
//           width: screenWidth * 0.16,
//           child: DelayAnimation(
//             delay: 0,
//             shouldFaded: false,
//             sliding: false,
//             is_faded_animation: false,
//             child: FlareActor(
//               "assets/all/reflectly_head_expressions.flr",
//               alignment: Alignment.center,
//               fit: BoxFit.contain,
//               animation: "look_down_excited",
//             ),
//           ),
//         )
//       ]),
//     ),
//   );
// }

class reflectly_face extends StatefulWidget {
  const reflectly_face({Key? key}) : super(key: key);

  @override
  State<reflectly_face> createState() => _reflectly_faceState();
}

class _reflectly_faceState extends State<reflectly_face> {
  String stat = "look_down_excited";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    Repository<String, Entry> repo = Repository(name: "entry_box");
    await repo.init();
    List<Entry> l = await repo.getAll();
    l.sort(
      (a, b) => b.submitTime.compareTo(a.submitTime),
    );
    for (var i = 0; i < l.length; i++) {
      if (l[i] is MoodCheckin) {
        double m = (l[i] as MoodCheckin).mood;
        if (m < 3) {
          setState(() {
            stat = m < 1 ? "look_down_sad" : "look_down_curious";
          });
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () {
        try {
          DateTime scheduledDate =
              DateTime.now().add(const Duration(seconds: 5));
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
        height: screenWidth * 0.3,
        width: screenWidth * 0.3,
        child: Stack(
          alignment: Alignment.center,
          children: [
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
                  animation: stat,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
