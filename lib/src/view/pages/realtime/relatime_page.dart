import 'dart:convert';

import 'package:altogic_flutter_example/src/service/realtime.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/case.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/input.dart';
import 'package:flutter/material.dart';

import '../../widgets/documentation/texts.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({Key? key}) : super(key: key);

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
  RealtimeService service = RealtimeService();

  final widgets = [
    ConnectMethod.new,
    DisconnectMethod.new,
    OnMessage.new,
    BroadcastMethod.new,
    JoinChannel.new,
    LeaveChannel.new,
    SendMethod.new,
    GetMembers.new,
    UpdateUserData.new,
  ];

  _set() {
    setState(() {});
  }

  @override
  void initState() {
    service.realtime.onConnect((p0) {
      debugPrint("On connect : $p0");
      _set();
    });
    service.realtime.onDisconnect((p0) {
      debugPrint("On disconnect : $p0");
      _set();
    });

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () async {
        RealtimeService.of(context).realtime.close();
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedService(
        service: service,
        child: BaseViewer(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color:
                    service.realtime.isConnected() ? Colors.green : Colors.red,
                child: Text(
                  service.realtime.isConnected() ? "Connected" : "Disconnected",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: Column(
                    children: [
                      const Documentation(children: [
                        Header('Realtime Manager'),
                        vSpace,
                      ]),
                      ...widgets.map((e) => MethodWidget(
                            create: e,
                            response: service.response,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ConnectMethod extends MethodWrap {
  ConnectMethod();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Open',
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context).open();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Connect to the realtime server'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Open";
}

class DisconnectMethod extends MethodWrap {
  DisconnectMethod();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Close',
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context).close();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Disconnect to the realtime server'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Close";
}

class LiveWidget extends StatefulWidget {
  const LiveWidget({Key? key}) : super(key: key);

  @override
  State<LiveWidget> createState() => _LiveWidgetState();
}

class _LiveWidgetState extends State<LiveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, v) {
          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(_controller.value),
              shape: BoxShape.circle,
            ),
          );
        });
  }
}

class MessageArea extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const MessageArea({super.key, required this.messages, required this.event});

  final String event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LiveWidget(),
              const SizedBox(
                width: 30,
              ),
              Text('Event : $event'),
            ],
          ),
          Text('Message Count: ${messages.length}'),
          const Text('Messages: '),
          if (messages.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(0)),
              height: 400,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (c, i) {
                  return Text(
                      const JsonEncoder.withIndent('  ').convert(messages[i]));
                },
                reverse: true,
              ),
            )
          else
            const Text('No messages')
        ],
      ),
    );
  }
}

class OnMessage extends MethodWrap {
  OnMessage();

  final TextEditingController nameController = TextEditingController();
  String? listener;
  final ValueNotifier<int> messageCount = ValueNotifier<int>(0);
  final List<Map<String, dynamic>> messages = [];

  onMessage(p0) {
    messages.insert(0, p0);
    messageCount.value++;
  }

  @override
  List<Widget> children(BuildContext context) {
    return [
      (listener == null)
          ? Column(
              children: [
                AltogicInput(
                    hint: 'Event Name', editingController: nameController),
                vSpace.doc(context),
                AltogicButton(
                    body: 'On Message',
                    listenable: nameController,
                    enabled: () => nameController.text.isNotEmpty,
                    onPressed: () {
                      asyncWrapper(() async {
                        RealtimeService.of(context)
                            .on(nameController.text, onMessage);
                        listener = nameController.text;
                        setState(() {});
                        var v = nameController.text;
                        WidgetsBinding.instance
                            .addObserver(LifecycleEventHandler(
                          detachedCallBack: () async {
                            RealtimeService.of(context).off(v, onMessage);
                            listener = null;
                          },
                        ));
                      });
                    }),
              ],
            )
          : AltogicButton(
              body: 'Off Message',
              onPressed: () {
                asyncWrapper(() async {
                  RealtimeService.of(context).off(
                    nameController.text,
                    onMessage,
                  );
                  messages.clear();
                  messageCount.value = 0;
                  listener = null;
                  setState(() {});
                });
              }),
      if (listener != null)
        ValueListenableBuilder(
          valueListenable: messageCount,
          builder: (c, v, w) {
            return MessageArea(
              messages: messages,
              event: listener!,
            );
          },
        )
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('On message'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "On Message";
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final Future<void> Function()? resumeCallBack;
  final Future<void> Function()? detachedCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await detachedCallBack?.call();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack?.call();
        break;
    }
  }
}

class BroadcastMethod extends MethodWrap {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: 'Event Name', editingController: eventNameController),
      vSpace.doc(context),
      AltogicInput(hint: 'Message', editingController: messageController),
      vSpace.doc(context),
      AltogicButton(
          body: 'Broadcast',
          listenable: Listenable.merge([
            eventNameController,
            messageController,
          ]),
          enabled: () =>
              eventNameController.text.isNotEmpty &&
              messageController.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context)
                  .broadcast(eventNameController.text, messageController.text);
              messageController.clear();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Broadcast message to channel'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Broadcast";
}

class SendMethod extends MethodWrap {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController channelName = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: 'Channel Name', editingController: channelName),
      vSpace.doc(context),
      AltogicInput(hint: 'Event Name', editingController: eventNameController),
      vSpace.doc(context),
      AltogicInput(hint: 'Message', editingController: messageController),
      vSpace.doc(context),
      AltogicButton(
          body: 'Broadcast',
          listenable: Listenable.merge([
            eventNameController,
            messageController,
            channelName,
          ]),
          enabled: () =>
              eventNameController.text.isNotEmpty &&
              messageController.text.isNotEmpty &&
              channelName.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context).send(channelName.text,
                  eventNameController.text, messageController.text);
              messageController.clear();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Broadcast message to channel'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Broadcast";
}

class JoinChannel extends MethodWrap {
  TextEditingController channelNameController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    return [
      AltogicInput(
          hint: 'Channel Name', editingController: channelNameController),
      AltogicButton(
          body: 'Join',
          listenable: channelNameController,
          enabled: () => channelNameController.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context).join(channelNameController.text);

              setState(() {});
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Join channel'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Join Channel";
}

class LeaveChannel extends MethodWrap {
  TextEditingController channelNameController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(
          hint: 'Channel Name', editingController: channelNameController),
      AltogicButton(
          body: 'Leave',
          listenable: channelNameController,
          enabled: () => channelNameController.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context).leave(channelNameController.text);
              setState(() {});
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Leave channel'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Leave Channel";
}

class GetMembers extends MethodWrap {
  TextEditingController channelNameController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(
          hint: 'Channel Name', editingController: channelNameController),
      AltogicButton(
          body: 'Get Members',
          listenable: channelNameController,
          enabled: () => channelNameController.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context)
                  .getMembers(channelNameController.text);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Get members of channel'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Get Members";
}

class UpdateUserData extends MethodWrap {
  TextEditingController dataController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: 'Data', editingController: dataController),
      AltogicButton(
          body: 'Update User Data',
          listenable: dataController,
          enabled: () => dataController.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              RealtimeService.of(context).updateUserData(dataController.text);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Update User Data";
}
