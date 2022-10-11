import 'package:altogic_flutter_example/src/service/auth_service.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/pages/authorization/cases.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:flutter/material.dart';

import '../../widgets/documentation/texts.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  AuthService authService = AuthService();

  static const Widget space = SizedBox(
    height: 10,
  );

  List<Widget> list = [
    SignUpWithEmailMethod(),
    SignUpWithPhoneMethod(),
    SignInWithEmailMethod(),
    SignInWithPhoneMethod(),
    SignInWithCodeMethod(),
    SignInWithProviderMethod(),
    SignOutMethod(),
    SignOutAllMethod(),
    SignOutMethodAllEx(),
    GetAllSessionsMethod(),
    GetAllUserFromDbMethod(),
    ChangePassword(),
    GetAuthGrant(),
    ReSendVerificationEmailMethod(),
    ReSendVerificationCodeMethod(),
    SendMagicLinkMethod(),
    SendResetPwdEmailMethod(),
    SendResetPwdCodeMethod(),
    SendSignInCodeMethod(),
    ResetPwdWithToken(),
    ResetPwdWithCode(),
    ChangeEmail(),
    ChangePhone(),
    VerifyPhone()
  ];

  @override
  Widget build(BuildContext context) {
    return InheritedService(
      service: authService,
      child: BaseViewer(
          body: Column(
        children: [
          const Documentation(children: [
            Header("Authorization"),
            vSpace,
            AutoSpan("This page is used to authorize user in the system. "
                "It is used to get access token and refresh token. "),
          ]),
          const SizedBox(
            height: 40,
          ),
          space,
          ...list,
        ],
      )),
    );
  }
}
