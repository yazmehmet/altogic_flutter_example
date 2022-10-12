import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/main.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:flutter/cupertino.dart';

class EndpointService extends ServiceBase {
  static EndpointService of(BuildContext context) =>
      InheritedService.of<EndpointService>(context);

  Future<void> getMethod(int a, int b) async {
    var res = await altogic.endpoint.get('/test/get', queryParams: {
      'a': a,
      'b': b,
    }).asMap();
    response.response(res);
  }

  Future<void> postMethod(int a, int b) async {
    var res = await altogic.endpoint
        .post('/test/post', body: {'a': a, 'b': b}).asMap();
    response.response(res);
  }

  Future<APIResponse<Map<String, dynamic>>> deleteMethod(String id) async {
    var res = await altogic.endpoint.delete('/test/delete/$id').asMap();
    response.response(res);
    return res;
  }

  Future<void> putMethod(int a, int b) async {
    var res = await altogic.endpoint
        .put('/test/put', headers: {"a": a, "b": b}).asMap();
    response.response(res);
  }

  Future<List<Map<String, dynamic>>?> getObjects() async {
    var re = await altogic.db.model("count").sort('count', Direction.asc).get();
    response.response(re);
    if (re.errors == null) {
      return re.data!
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();
    } else {
      return null;
    }
  }
}
