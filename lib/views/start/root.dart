import 'package:flutter/material.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/views/start/root_viewmodel.dart';
import 'package:myrefectly/views/navigation/navigation.dart';
import 'package:myrefectly/views/other/security.dart';
import 'package:myrefectly/views/start/intro.dart';
import 'package:provider/provider.dart';

class ReflectlyApp extends StatefulWidget {
  @override
  _ReflectlyAppState createState() => _ReflectlyAppState();
}

class _ReflectlyAppState extends State<ReflectlyApp>
    with WidgetsBindingObserver {
  late Root_Viewmodel app_viewmodel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      print("Ứng dụng vào background");
      if (app_viewmodel.user.passcode)
        Navigator.push(
            context,
            Slide_up_Route(
                secondPage: SecurityRequest_Page(
              open_app: false,
            )));
    }
    // else if (state == AppLifecycleState.resumed) {
    //   print("Ứng dụng quay lại foreground");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Root_Viewmodel>(
        create: (context) => Root_Viewmodel(),
        child: Consumer<Root_Viewmodel>(builder: (context, view_model, child) {
          app_viewmodel = view_model;
          if (view_model.loading) return Container();

          if (view_model.user.refresh_token.length == 0)
            return const Intro_Page();
          if (view_model.user.passcode)
            return SecurityRequest_Page(
              open_app: true,
            );
          return NavigationPage();
        }));
  }
}
