import 'package:altogic_flutter_example/src/service/db_service.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/pages/database/market_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/base_viewer.dart';
import '../../widgets/documentation/base.dart';
import '../../widgets/documentation/texts.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({Key? key}) : super(key: key);

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  DbService dbService = DbService();

  @override
  Widget build(BuildContext context) {
    return InheritedService(
      service: dbService,
      child: BaseViewer(
          body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 30,
        ),
        child: Column(
          children: [
            const Documentation(children: [
              Header("Database Manager"),
              vSpace,
              AutoSpan("This page is used to show database operations"),
            ]),
            const SizedBox(
              height: 40,
            ),
            MarketView(
              responseViewController: dbService.response,
            ),
          ],
        ),
      )),
    );
  }
}
