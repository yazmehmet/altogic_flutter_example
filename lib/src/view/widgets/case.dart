import 'package:altogic_flutter_example/src/controller/response_controller.dart';
import 'package:flutter/material.dart';

import 'divider.dart';
import 'documentation/base.dart';
import 'documentation/texts.dart';

class _MethodWidgetService extends ChangeNotifier {
  bool get loading => _loading;
  bool _loading = false;

  MethodWidgetState? _state;

  void setState() {
    _state!._listener();
  }
}

typedef AsyncWrapper<T> = Future<T> Function(Future<T> Function() function);

abstract class MethodWidget extends StatefulWidget {
  String get name;

  List<DocumentationObject> get description;

  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder;

  MethodWidget({super.key, this.response});

  final _MethodWidgetService _service = _MethodWidgetService();

  final ResponseViewController? response;

  bool get loading => _service.loading;

  Widget build(BuildContext context, void Function(void Function()) setState);

  Future<T> asyncWrapper<T>(Future<T> Function() function) async {
    _service._loading = true;
    _service._state?._listener();
    try {
      return await function();
    } finally {
      _service._loading = false;
      _service._state?._listener();
    }
  }

  @override
  MethodWidgetState createState() => MethodWidgetState();
}

abstract class MethodWrap extends MethodWidget {
  MethodWrap({super.key, super.response});

  List<Widget> children(
      BuildContext context, void Function(void Function()) setState);

  @override
  Widget build(BuildContext context, void Function(void Function()) setState) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children(context, setState),
    );
  }
}

class MethodWidgetState<T extends MethodWidget> extends State<T> {
  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    widget._service._state = this;
    super.initState();
  }

  @override
  void dispose() {
    widget._service._state = null;
    super.dispose();
  }

  Future<E> asyncWrapper<E>(Future<E> Function() function) async {
    return widget.asyncWrapper<E>(function);
  }

  bool get loading => widget.loading;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const AltogicDivider(),
      const SizedBox(
        height: 10,
      ),
      Row(children: [
        Expanded(
            child: Documentation(
                children: [Header(widget.name, level: 2), vSpace])),
        const SizedBox(
          width: 10,
        ),
        if (widget.documentationBuilder != null) ...[
          Container(
            width: 40,
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (c) => SimpleDialog(
                            children: [
                              SimpleDialogOption(
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(30),
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Documentation(
                                    children: [
                                      Header(widget.name, level: 2),
                                      vSpace,
                                      ...widget.documentationBuilder!(c)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ));
                },
                icon: const Icon(Icons.info)),
          )
        ]
      ]),
      Documentation(children: [...widget.description, vSpace]),
      const SizedBox(
        height: 10,
      ),
      widget.build(context, setState),
      const SizedBox(
        height: 30,
      ),
    ]);
  }
}
