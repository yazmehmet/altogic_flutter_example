import 'dart:typed_data';

import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/pages/storage/utils/upload.dart'
    if (dart.library.html) 'package:altogic_flutter_example/src/view/pages/storage/utils/web_upload.dart'
    if (dart.library.io) 'package:altogic_flutter_example/src/view/pages/storage/utils/io_upload.dart'
    show download;
import 'package:flutter/material.dart';

import '../../main.dart';

class FileManagerService extends ServiceBase {
  FileManagerService(this.bucket, this.fileNameOrId);

  static FileManagerService of(BuildContext context) =>
      InheritedService.of<FileManagerService>(context);
  ValueNotifier<Map<String, dynamic>?> fileInfo =
      ValueNotifier<Map<String, dynamic>?>(null);
  final String fileNameOrId;
  final String bucket;

  FileManager get file => altogic.storage.bucket(bucket).file(fileNameOrId);

  Future<void> exists() async {
    response.value = 'Loading...';
    var res = await file.exists();
    response.response(res);
  }

  Future<Map<String, dynamic>?> getInfo() async {
    response.value = 'Loading...';
    var res = await file.getInfo();
    response.response(res);
    if (res.data != null) {
      fileInfo.value = res.data;
    }
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

  Future<Uint8List?> downloadFile() {
    response.value = 'Loading...';
    return file.download().then((value) async {
      var info = await getInfo();
      response.value = 'Downloaded : ${value.data?.length} bytes';
      download(info!['fileName'], value.data!);
    }).catchError((e) {
      response.value = 'Error: $e';
    });
  }

  Future<void> rename(String newName) async {
    response.value = 'Loading...';
    var res = await file.rename(newName);
    response.response(res);
    getInfo();
  }

  Future<void> duplicate(String newName) async {
    response.value = 'Loading...';
    var res = await file.duplicate(newName);
    response.response(res);
  }

  Future<void> delete() async {
    response.value = 'Loading...';
    var res = await file.delete();
    getInfo();
    response.error(res);
  }

  Future<void> replace(Uint8List data, void Function(int, int, double) onLoad,
      String contentType) async {
    response.value = 'Loading...';
    var res = await file.replace(
        data, FileUploadOptions(contentType: contentType, onProgress: onLoad));
    response.response(res);
  }

  Future<void> moveTo(String bucketNameOrId) async {
    response.value = 'Loading...';
    var res = await file.moveTo(bucketNameOrId);
    response.response(res);
  }

  Future<void> copyTo(String bucketNameOrId) async {
    response.value = 'Loading...';
    var res = await file.copyTo(bucketNameOrId);
    response.response(res);
  }

  Future<void> addTags(List<String> tags) async {
    response.value = 'Loading...';
    var res = await file.addTags(tags);
    response.response(res);
    getInfo();
  }

  Future<void> removeTags(List<String> tags) async {
    response.value = 'Loading...';
    var res = await file.removeTags(tags);
    getInfo();
    response.response(res);
  }

  Future<void> updateInfo(
      {String? newName,
      required bool isPublic,
      required List<String> tags}) async {
    response.value = 'Loading...';
    var res =
        await file.updateInfo(newName: newName, isPublic: isPublic, tags: tags);
    response.response(res);
    getInfo();
  }

  Future<dynamic> listBucket(
      {required int limit,
      required int page,
      required bool returnCountInfo,
      required BucketSortField sort,
      required bool asc,
      String? expression}) async {
    response.value = 'Loading...';
    final res = await altogic.storage.listBuckets(
        expression: expression,
        options: BucketListOptions(
            limit: limit,
            page: page,
            returnCountInfo: returnCountInfo,
            sort: BucketSortEntry(
                direction: asc ? Direction.asc : Direction.desc, field: sort)));
    response.response(res);
    return res.data;
  }
}
