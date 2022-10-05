import 'dart:convert';

import 'package:altogic_flutter_example/src/service/auth_service.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/code.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:altogic_flutter_example/src/view/widgets/input.dart';
import 'package:flutter/material.dart';

class ResetPwdRedirect extends StatefulWidget {
  const ResetPwdRedirect({Key? key, required this.arguments}) : super(key: key);

  final Map<String, dynamic> arguments;

  @override
  State<ResetPwdRedirect> createState() => _ResetPwdRedirectState();
}

class _ResetPwdRedirectState extends State<ResetPwdRedirect> {
  ValueNotifier<String> response = ValueNotifier<String>('Getting grant...');

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  _get() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!widget.arguments.containsKey('access_token')) {
      response.value = 'Path arguments *incorrect*. For reset password,'
          ' `access_token` *must be provided*.';
      return;
    }
    response.value = '';
    await authService.resetPwdWithToken(
        widget.arguments['access_token']!, password.text);
    if (authService.currentUserController.isLogged) {
      response.value = 'Success';
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
                const Header('Set New Password'),
                vSpace,
                const Description('Documentation will be added'),
                vSpace,
                const Header('Arguments', level: 3),
                vSpace,
                DartCode(const JsonEncoder.withIndent('   ')
                    .convert(widget.arguments)),
              ]),
              vSpace.doc(context),
              AltogicInput(hint: 'New Password', editingController: password),
              vSpace.doc(context),
              AltogicButton(
                  body: "Change",
                  onPressed: () {
                    _get();
                  }),
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
