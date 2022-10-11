import 'package:altogic_flutter_example/src/service/queue_service.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/case.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/code.dart';
import 'package:altogic_flutter_example/src/view/widgets/input.dart';
import 'package:flutter/material.dart';
import '../widgets/documentation/texts.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({Key? key}) : super(key: key);

  @override
  State<QueuePage> createState() => _QueuePagePageState();
}

class _QueuePagePageState extends State<QueuePage> {
  QueueService taskService = QueueService();

  final TextEditingController idController = TextEditingController();

  late List<Widget> widgets = [
    RunQueueMethod(controller: idController),
    GetMessageStatus(
      controller: idController,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return InheritedService(
        service: taskService,
        child: BaseViewer(
          body: Column(
            children: [
              const Documentation(children: [
                Header("Queue Manager"),
                vSpace,
                AutoSpan(
                    "This page is used to manage queue. It is used to run and get status."),
                vSpace
              ]),
              ...widgets
            ],
          ),
        ));
  }
}

class RunQueueMethod extends MethodWrap {
  RunQueueMethod({super.key, required this.controller});

  final TextEditingController controller;

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicButton(
          body: "Submit Message",
          onPressed: () {
            asyncWrapper(() async {
              await QueueService.of(context).submitMessage(controller);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("This method is used to submit message queue."),
        vSpace,
        const AutoSpan('There is a queue with name "hello" in this project.'),
        vSpace,
        const AutoSpan(
            "To submit message to queue you need to call `submitMessage`."),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => (c) => [
            const AutoSpan("This method is used to submit message queue."),
            vSpace,
            const AutoSpan(
                'There is a queue with name "hello" in this project.'),
            vSpace,
            const AutoSpan(
                "To submit message to queue you need to call `submitMessage`."),
            vSpace,
            const DartCode("""
var res = await altogic.queue.submitMessage("hello", {
  "entry": {
    "key1": "value1",
  }
});
if (res.errors == null) {
  // success
}
    """)
          ];

  @override
  String get name => "Submit Message";
}

class GetMessageStatus extends MethodWrap {
  GetMessageStatus({super.key, required this.controller});

  final TextEditingController controller;

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: 'Message ID', editingController: controller),
      AltogicButton(
          body: "Get Status",
          enabled: () => controller.text.length == 24,
          listenable: controller,
          onPressed: () {
            asyncWrapper(() async {
              await QueueService.of(context).getMessageStatus(
                controller.text,
              );
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("This method is used to get message status."),
        vSpace,
        const AutoSpan(
            "To get task status you need to call `getMessageStatus`"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => (c) => [
            const AutoSpan("This method is used to get message status."),
            vSpace,
            const AutoSpan(
                "To get task status you need to call `getMessageStatus`"),
            vSpace,
            DartCode("""
var res = await altogic.task.getMessageStatus("${controller.text}");
if (res.errors == null) {
  // success
}
    """)
          ];

  @override
  String get name => "Get Status";
}
