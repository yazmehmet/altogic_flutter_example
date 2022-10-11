
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Uint8List getUintList(PlatformFile file){
  return File(file.path!).readAsBytesSync();
}