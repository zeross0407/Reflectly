import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/notification/vip.dart';
import 'package:myrefectly/views/start/init_viewmodel.dart';
import 'package:myrefectly/views/start/root.dart';
import 'package:provider/provider.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    NotificationService.init();
    NotificationService.showInstantNotification("Reflectly","Hi, Welcome back");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Init_Viewmodel>(
        create: (context) => Init_Viewmodel(),
        child: Consumer<Init_Viewmodel>(builder: (context, viewModel, child) {
          if (!viewModel.loading) {
            Future.microtask(
              () => Navigator.pushReplacement(
                  context, Slide_up_Route(secondPage: ReflectlyApp())),
            );
          }
          return Scaffold(
            body: Center(
              child: SvgPicture.asset(
                'assets/ico/notebook.svg',
                width: 150,
                height: 150,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.05), BlendMode.srcIn),
              ),
            ),
          );
        }));
  }
}
