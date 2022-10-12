import 'package:altogic_flutter_example/src/controller/user_controller.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/code.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Set<String> _authRequired = {
    '/database',
    '/chat',
    '/task',
    '/queue',
    '/storage',
    '/realtime',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: AltogicAppBar()),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Documentation(children: [
                  Header('Setting Up Client'),
                  vSpace,
                  Description("Inline Code Example"),
                  vSpace,
                  DartCode(
                      "final client = createClient('<envUrl>', '<clientKey>');")
                ]),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var page in pages.keys.toList()..remove('/'))
                        ...() {
                          var logged = CurrentUserController().isLogged;
                          return [
                            AltogicButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(page);
                                },
                                enabled: () =>
                                    !_authRequired.contains(page) || logged,
                                body: routeNames[page]!),
                            if (!logged && _authRequired.contains(page))
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Login Required',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            )
                          ];
                        }(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
