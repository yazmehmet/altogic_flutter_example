import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../service/auth_service.dart';
import '../../../service/service_base.dart';
import '../../widgets/base_viewer.dart';
import '../../widgets/documentation/base.dart';
import '../../widgets/documentation/code.dart';
import '../../widgets/documentation/texts.dart';

class RedirectProvider extends StatefulWidget {
  const RedirectProvider({Key? key, required this.arguments}) : super(key: key);

  final Map<String, dynamic> arguments;

  @override
  State<RedirectProvider> createState() => _RedirectProviderState();
}

class _RedirectProviderState extends State<RedirectProvider> {
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
      response.value = 'Path arguments *incorrect*. For verify email,'
          ' `access_token` *must be provided*.';
      return;
    }
    response.value = '';
    await authService.getAuthGrant(widget.arguments['access_token']!);
    if (authService.currentUserController.isLogged) {
      response.value = 'Signed In!';
    }
  }

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
                const Header('Oauth Redirect Page'),
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
