import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';

import '../../main.dart';

class FileManagerService extends ServiceBase {
  FileManagerService(this.bucket, this.fileNameOrId);

  final String fileNameOrId;
  final String bucket;

  FileManager get file => altogic.storage.bucket(bucket).file(fileNameOrId);

  Future<void> exists() async {
    response.value = 'Loading...';
    var res = await file.exists();
    response.response(res);
  }

  Future<Map<String,dynamic>?> getInfo() async {
    response.value = 'Loading...';
    var res = await file.getInfo();
    response.response(res);
    return res.data;
  }


  Future<void> makePublic() async {
    response.value = 'Loading...';
    var res = await file.makePublic();
    response.response(res);
  }


  Future<void> makePrivate() async {
    response.value = 'Loading...';
    var res = await file.makePrivate();
    response.response(res);
  }



}
