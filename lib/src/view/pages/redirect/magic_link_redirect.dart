import 'dart:convert';

import 'package:altogic_flutter_example/src/service/auth_service.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/code.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:flutter/material.dart';

class MagicLinkRedirect extends StatefulWidget {
  const MagicLinkRedirect({Key? key, required this.arguments})
      : super(key: key);

  final Map<String, dynamic> arguments;

  @override
  State<MagicLinkRedirect> createState() => _MagicLinkRedirectState();
}

class _MagicLinkRedirectState extends State<MagicLinkRedirect> {
  ValueNotifier<String> response = ValueNotifier<String>('Getting grant...');

  AuthService authService = AuthService();

  @override
  void initState() {
    _get();
    super.initState();
  }

  _get() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!widget.arguments.containsKey('access_token')) {
      response.value =
          'Path arguments *incorrect*. For signing in with provider,'
          ' `access_token` *must be provided*.';
      return;
    }
    response.value = '';
    await authService
        .getAuthGrant(widget.arguments['access_token']!)
       ;
    if (authService.currentUserController.isLogged) {
      response.value = 'Signed in';
    } else {
      response.value = 'Failed to sign in';
    }
  }

  final TextEditingController password = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return InheritedService(
      service: authService,
      child: BaseViewer(
        leadingHome: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Documentation(children: [
                vSpace,
                const Header('Magic Link Redirect'),
                vSpace,
                const Description('Documentation will be added'),
                vSpace,
                const Header('Arguments', level: 3),
                vSpace,
                DartCode(const JsonEncoder.withIndent('   ')
                    .convert(widget.arguments)),
              ]),
              vSpace.doc(context),
              ValueListenableBuilder(
                  valueListenable: response,
                  builder: (c, v, w) {
                    return Documentation(children: [AutoSpan(v)]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
