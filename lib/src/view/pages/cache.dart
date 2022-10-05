import 'package:altogic_flutter_example/src/service/cache_service.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/case.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:altogic_flutter_example/src/view/widgets/input.dart';
import 'package:flutter/material.dart';

import '../widgets/documentation/base.dart';
import '../widgets/documentation/code.dart';

class CachePage extends StatefulWidget {
  const CachePage({Key? key}) : super(key: key);

  @override
  State<CachePage> createState() => _CachePageState();
}

class _CachePageState extends State<CachePage> {
  CacheService cacheService = CacheService();

  List<Widget> widgets = [
    SetCacheMethod(),
    GetCacheMethod(),
    DeleteCacheMethod(),
    IncrementCacheMethod(),
    DecrementCacheMethod(),
    ExpireCacheMethod(),
    GetStatsCacheMethod(),
    ListKeysMethod()
  ];

  @override
  Widget build(BuildContext context) {
    return InheritedService(
        service: cacheService,
        child: BaseViewer(
            body: Column(
          children: [
            const Documentation(children: [
              Header("Cache Manager"),
              vSpace,
              AutoSpan("This page is used to show cache operations"),
              vSpace,
              AutoSpan("To get an `CacheManager`, you need to use an "
                  "expression: `altogic.endpoint` "),
              vSpace,
              AutoSpan("With `CacheManager`, you can call following methods."),
              vSpace,
            ]),
            ...widgets
          ],
        )));
  }
}

class SetCacheMethod extends MethodWrap {
  SetCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Key", editingController: keyController),
      AltogicInput(hint: "Value (integer)", editingController: valueController),
      AltogicInput(hint: "TTL (optional)", editingController: ttlController),
      AltogicButton(
        body: "Set Cache",
        onPressed: () {
          CacheService.of(context).setCache(
              keyController.text,
              int.tryParse(valueController.text),
              int.tryParse(ttlController.text));
        },
        enabled: () =>
            keyController.text.isNotEmpty &&
            valueController.text.isNotEmpty &&
            int.tryParse(valueController.text) != null &&
            (ttlController.text.isEmpty ||
                int.tryParse(ttlController.text) != null),
        listenable: Listenable.merge([keyController, valueController]),
      )
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Set Cache Value')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Set Cache Value";
}

class GetCacheMethod extends MethodWrap {
  GetCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Key", editingController: keyController),
      AltogicButton(
        body: "Get Cache",
        onPressed: () {
          CacheService.of(context).getCache(keyController.text);
        },
        enabled: () => keyController.text.isNotEmpty,
        listenable: Listenable.merge([keyController]),
      )
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Get Cache Value')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Get Cache Value";
}

// delete cache
class DeleteCacheMethod extends MethodWrap {
  DeleteCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Key", editingController: keyController),
      AltogicButton(
        body: "Delete Cache",
        onPressed: () {
          CacheService.of(context).deleteCache(keyController.text);
        },
        enabled: () => keyController.text.isNotEmpty,
        listenable: Listenable.merge([keyController]),
      )
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Delete Cache Value')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Delete Cache Value";
}

class IncrementCacheMethod extends MethodWrap {
  IncrementCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Key", editingController: keyController),
      AltogicInput(hint: "Amount", editingController: amountController),
      AltogicButton(
        body: "Increment Cache",
        onPressed: () {
          CacheService.of(context).increment(
              keyController.text, int.tryParse(amountController.text)!);
        },
        enabled: () =>
            keyController.text.isNotEmpty &&
            int.tryParse(amountController.text) != null,
        listenable: Listenable.merge([keyController, amountController]),
      )
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Increment Cache Value')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Increment Cache Value";
}

class DecrementCacheMethod extends MethodWrap {
  DecrementCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Key", editingController: keyController),
      AltogicInput(hint: "Amount", editingController: amountController),
      AltogicButton(
        body: "Decrement Cache",
        onPressed: () {
          CacheService.of(context).decrement(
              keyController.text, int.tryParse(amountController.text)!);
        },
        enabled: () =>
            keyController.text.isNotEmpty &&
            int.tryParse(amountController.text) != null,
        listenable: Listenable.merge([keyController, amountController]),
      )
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Decrement Cache Value')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Decrement Cache Value";
}

class ExpireCacheMethod extends MethodWrap {
  ExpireCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Key", editingController: keyController),
      AltogicInput(hint: "TTL", editingController: ttlController),
      AltogicButton(
        body: "Expire Cache",
        onPressed: () {
          CacheService.of(context)
              .expire(keyController.text, int.tryParse(ttlController.text)!);
        },
        enabled: () =>
            keyController.text.isNotEmpty &&
            int.tryParse(ttlController.text) != null,
        listenable: Listenable.merge([keyController, ttlController]),
      )
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Expire Cache Value')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Expire Cache Value";
}

class GetStatsCacheMethod extends MethodWrap {
  GetStatsCacheMethod({super.key});

  final TextEditingController keyController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicButton(
        body: "Get Stats",
        onPressed: () {
          CacheService.of(context).getStats();
        },
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [const AutoSpan('Get Stats')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Get Stats";
}

class ListKeysMethod extends MethodWrap {
  ListKeysMethod({super.key});

  final TextEditingController expressionController = TextEditingController();
  final TextEditingController nextController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "Pattern", editingController: expressionController),
      AltogicInput(hint: "Next", editingController: expressionController),
      AltogicButton(
        body: "List Keys",
        onPressed: () {
          CacheService.of(context)
              .listKeys(expressionController.text, nextController.text);
        },
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [const AutoSpan('List Keys')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "List Keys";
}
