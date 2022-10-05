import 'dart:convert';

import 'package:altogic_flutter_example/src/controller/response_controller.dart';
import 'package:altogic_flutter_example/src/controller/user_controller.dart';
import 'package:altogic_flutter_example/src/service/db_service.dart';
import 'package:altogic_flutter_example/src/view/pages/database/cases.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/code.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:flutter/material.dart';

class MarketView extends StatefulWidget {
  const MarketView({Key? key, required this.responseViewController})
      : super(key: key);
  final ResponseViewController responseViewController;

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  CurrentUserController currentUserController = CurrentUserController();

  @override
  void initState() {
    currentUserController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    currentUserController.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  final widgets = [
    GetMarketWithObjectId(), // object.get
    GetMarketWithFilter(), // query.filter
    GetMarketWithLookup(), // query.lookup
    ChangeMarketName(), // object.update
    GetContact(), // object.get for sub
    AddMarketContact(), // append
    DeleteContact(), // object.delete for sub
    DeleteContactWithFilter(), // query.filter.delete sub
    ChangeMarketAddress(), // object.update // set
    UnsetMarketAddress(), // query.filter.update // unset
    CreateProduct(), // create
    GetMarketProducts(), // query.filter // page // limit
    OmitProduct(),
    ChangePrice(), // query.filter.update
    DeleteProduct(), // object.delete
    DeleteProductWithQueryBuilder(), // query.delete
    IncrementDecrement(), // (amount) // object.updateFields // inc // dec
    PushProperty(), // query.filter.updateFields // push
    PullProperty(), // object.updateFields // pull
    SearchProducts(), // search
    SearchFuzzyProducts(), // search fuzzy
    GroupCategories(), // filter / group / compute / count
    GetMarketWithAvgPrice(), // filter / compute / avg
    GetMarketWithTotalStockValue(),
    GetMarketProductCount() // filter / compute / count
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AutoSpan(
                "This page is used to show database operations with a simple "
                "scenario. The scenario is ... (will be added)")
            .doc(context),
        Image.network(
            'https://c1-na.altogic.com/_storage/62d3ea1510b444043a4f80b7/62d3ea1510b444043a4f80b7/6336f0b778ce5bb8a7f3e0ec'),
        vSpace.doc(context),
        if (!currentUserController.hasMarket) ...[
          const AutoSpan("You have to create a market first.").doc(context),
          vSpace.doc(context),
          const AutoSpan("You can create a market with the following form:")
              .doc(context),
          vSpace.doc(context),
          CreateMarketCase(response: DbService.of(context).response)
        ],
        if (currentUserController.hasMarket) ...[
          Documentation(children: [
            const AutoSpan("Now, you have a market!"),
            vSpace,
            AutoSpan("Market:\n${const JsonEncoder.withIndent('    '
                '').convert(currentUserController.market.toJson())}"),
            vSpace,
            const Header('Model', level: 2),
            vSpace,
            const AutoSpan(
                "In order to perform database operations, we first need to know which model we will operate on : \n\n"),
            const DartCode("""
altogic.db.model('model_name');
"""),
            vSpace,
            const AutoSpan(
                "In this example, we will use the model named 'market'."),
            vSpace,
            const AutoSpan(
                '`.model` expression returns a `QueryBuilder` object which you can'
                ' do all operations on it.'),
            vSpace,
            const AutoSpan("You can use the following operations on the"
                " `QueryBuilder` and `DbObject`:"),
            vSpace,
          ]),
          ...widgets
        ],
      ],
    );
  }
}
