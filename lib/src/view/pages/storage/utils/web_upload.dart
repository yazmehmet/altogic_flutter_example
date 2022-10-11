
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

Uint8List getUintList(PlatformFile file){
  return file.bytes!;
}


