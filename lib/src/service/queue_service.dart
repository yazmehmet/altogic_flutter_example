import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/main.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:flutter/cupertino.dart';

class QueueService extends ServiceBase {
  static QueueService of(BuildContext context) =>
      InheritedService.of<QueueService>(context);

  Future<void> submitMessage(TextEditingController controller) async {
    var res = await altogic.queue.submitMessage('hello', {
      'entry': {
        "key1": "value1",
      }
    });
    response.response(APIResponse(
      errors: res.errors,
      data: res.data?.toJson(),
    ));
    controller.text = res.data?.messageId ?? '';
  }

  ValueNotifier<String?> id = ValueNotifier<String?>(null);

  Future<void> getMessageStatus(String messageId) async {
    var res = await altogic.queue.getMessageStatus(messageId);
    response.response(APIResponse(
      errors: res.errors,
      data: res.data?.toJson(),
    ));
  }
}
