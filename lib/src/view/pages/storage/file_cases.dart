import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/src/service/file_manager.dart';
import 'package:altogic_flutter_example/src/service/suggestion_service.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/case.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:altogic_flutter_example/src/view/widgets/input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../database/cases.dart';
import 'utils/upload.dart'
    if (dart.library.io) 'utils/io_upload.dart'
    if (dart.library.html) 'utils/web_upload.dart' show getUintList;

class FileExistsCase extends MethodWrap {
  FileExistsCase();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Get File Exists',
          onPressed: () {
            asyncWrapper(() async {
              FileManagerService.of(context).exists();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Get File Exists')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Get File Exists';
}

class GetFileInfoMethod extends MethodWrap {
  GetFileInfoMethod();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Get File Info',
          onPressed: () {
            asyncWrapper(() async {
              FileManagerService.of(context).getInfo();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Get File Info')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Get File Info';
}

class MakeFilePublic extends MethodWrap {
  MakeFilePublic();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Make File Public',
          onPressed: () {
            asyncWrapper(() async {
              FileManagerService.of(context).makePublic();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Make File Public')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Make File Public';
}

class MakeFilePrivate extends MethodWrap {
  MakeFilePrivate();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Make File Private',
          onPressed: () {
            asyncWrapper(() async {
              FileManagerService.of(context).makePrivate();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Make File Private')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Make File Private';
}

class DownloadFileCase extends MethodWrap {
  DownloadFileCase();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Download File',
          onPressed: () {
            asyncWrapper(() async {
              FileManagerService.of(context).downloadFile();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Download File')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Download File';
}

class RenameFileCase extends MethodWrap {
  RenameFileCase();

  String get fileName =>
      FileManagerService.of(context).fileInfo.value!['fileName'];
  late final TextEditingController controller =
      TextEditingController(text: fileName);

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: "New Name", editingController: controller),
      AltogicButton(
          body: 'Rename File',
          enabled: () {
            return controller.text.isNotEmpty && controller.text != fileName;
          },
          listenable: controller,
          onPressed: () {
            asyncWrapper(() async {
              await FileManagerService.of(context).rename(controller.text);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [const AutoSpan('Rename File')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Rename File';
}

class DuplicateFileCase extends MethodWrap {
  DuplicateFileCase();

  String get fileName =>
      FileManagerService.of(context).fileInfo.value!['fileName'];
  late final TextEditingController controller =
      TextEditingController(text: fileName);

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: "New Name", editingController: controller),
      AltogicButton(
          body: 'Duplicate File',
          enabled: () =>
              controller.text.isNotEmpty && controller.text != fileName,
          listenable: controller,
          onPressed: () {
            asyncWrapper(() async {
              FileManagerService.of(context).duplicate(controller.text);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description =>
      [const AutoSpan('Duplicate File')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Duplicate File';
}

class DeleteFileMethod extends MethodWrap {
  DeleteFileMethod();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
          body: 'Delete File',
          onPressed: () {
            asyncWrapper(() async {
              await FileManagerService.of(context).delete();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [const AutoSpan('Delete File')];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => 'Delete File';
}

class ReplaceFileMethod extends MethodWrap {
  ReplaceFileMethod();

  final ValueNotifier<PlatformFile?> bytes = ValueNotifier<PlatformFile?>(null);
  final ValueNotifier<double?> process = ValueNotifier<double?>(null);

  static final Map<String, String> contentTypes = {
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'webp': 'image/webp',
    'gif': 'image/gif',
    'mp4': 'video/mp4',
    'mp3': 'audio/mpeg',
    'mov': 'video/quicktime',
    'wav': 'audio/wav',
    'json': 'application/json',
    'txt': 'text/plain',
    'html': 'text/html',
    'css': 'text/css',
    'js': 'application/javascript',
  };

  @override
  List<Widget> children(BuildContext context) {
    return [
      ValueListenableBuilder<PlatformFile?>(
        valueListenable: bytes,
        builder: (context, value, child) {
          if (value != null) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "File Selected : ${value.name}",
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              bytes.value = null;
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete_forever))
                      ],
                    ),
                  ),
                ),
                vSpace.doc(context),
                Text(
                    "content type: ${value.extension != null ? contentTypes[value.extension] : 'text/plain'}"),
              ],
            );
          }
          return AltogicButton(
              enabled: () => !loading,
              body: 'Select File',
              onPressed: () async {
                asyncWrapper(() async {
                  var file = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: contentTypes.keys.toList());
                  if (file != null) {
                    bytes.value = file.files.first;
                  }
                });
              });
        },
      ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      ValueListenableBuilder(
          valueListenable: process,
          builder: (c, v, w) {
            if (process.value != null) {
              return Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: LinearProgressIndicator(
                        value: process.value,
                        color: Colors.blue,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Text("% ${(process.value! * 100).toStringAsFixed(2)}")
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      ValueListenableBuilder(
          valueListenable: bytes,
          builder: (c, v, w) {
            return AltogicButton(
                enabled: () {
                  if (kDebugMode) {
                    print(bytes.value != null);
                  }
                  return !loading && bytes.value != null;
                },
                listenable: Listenable.merge([bytes]),
                body: 'Replace File',
                onPressed: () {
                  asyncWrapper(() async {
                    await FileManagerService.of(context)
                        .replace(getUintList(bytes.value!), (l, t, percent) {
                      process.value = t / l;
                    },
                            bytes.value!.extension != null
                                ? contentTypes[bytes.value!.extension]!
                                : 'text/plain');

                    process.value = null;
                    bytes.value = null;
                  });
                });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Replace file in the bucket with same name.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Replace File";
}

class MoveToBucketFileMethod extends MethodWrap {
  final TextEditingController bucketName = TextEditingController();
  final SuggestionService suggestionService = SuggestionService();

  MoveToBucketFileMethod();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: "Bucket Name Or ID", editingController: bucketName),
      vSpace.doc(context),
      ...suggestionService.getWidget(
          context,
          (limit, page) async {
            var res = await FileManagerService.of(context).listBucket(
                expression: 'userId == "${currentUser.user.id}"',
                sort: BucketSortField.createdAt,
                returnCountInfo: false,
                page: page,
                limit: limit,
                asc: false);
            return (res as List?)
                ?.map((e) => (e as Map).cast<String, dynamic>())
                .toList();
          },
          (map) => map['name'],
          setState,
          (id) {
            bucketName.text = id;
          }),
      vSpace.doc(context),
      AltogicButton(
          body: "Get Suggestions",
          onPressed: () {
            asyncWrapper(() async {
              suggestionService.page = 1;
              var res = await FileManagerService.of(context).listBucket(
                  expression: 'userId == "${currentUser.user.id}"',
                  limit: suggestionService.limit,
                  page: suggestionService.page,
                  returnCountInfo: false,
                  sort: BucketSortField.createdAt,
                  asc: false);
              suggestionService.values = (res as List?)
                      ?.map((e) => (e as Map).cast<String, dynamic>())
                      .toList() ??
                  [];
              setState(() {});
            });
          }),
      AltogicButton(
        body: "Move To Bucket",
        onPressed: () {
          asyncWrapper(() async {
            await FileManagerService.of(context).moveTo(bucketName.text);
          });
          return;
        },
        enabled: () => bucketName.text.isNotEmpty,
        listenable: bucketName,
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Move file to another bucket.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Move To Bucket";
}

class CopyToBucketFileMethod extends MethodWrap {
  final TextEditingController bucketName = TextEditingController();
  final SuggestionService suggestionService = SuggestionService();

  CopyToBucketFileMethod();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: "Bucket Name Or ID", editingController: bucketName),
      vSpace.doc(context),
      ...suggestionService.getWidget(
          context,
          (limit, page) async {
            var res = await FileManagerService.of(context).listBucket(
                expression: 'userId == "${currentUser.user.id}"',
                sort: BucketSortField.createdAt,
                returnCountInfo: false,
                page: page,
                limit: limit,
                asc: false);
            return (res as List?)
                ?.map((e) => (e as Map).cast<String, dynamic>())
                .toList();
          },
          (map) => map['name'],
          setState,
          (id) {
            bucketName.text = id;
          }),
      vSpace.doc(context),
      AltogicButton(
          body: "Get Suggestions",
          onPressed: () {
            asyncWrapper(() async {
              suggestionService.page = 1;
              var res = await FileManagerService.of(context).listBucket(
                  expression: 'userId == "${currentUser.user.id}"',
                  limit: suggestionService.limit,
                  page: suggestionService.page,
                  returnCountInfo: false,
                  sort: BucketSortField.createdAt,
                  asc: false);
              suggestionService.values = (res as List?)
                      ?.map((e) => (e as Map).cast<String, dynamic>())
                      .toList() ??
                  [];
              setState(() {});
            });
          }),
      AltogicButton(
        body: "Copy To Bucket",
        onPressed: () {
          asyncWrapper(() async {
            await FileManagerService.of(context).copyTo(bucketName.text);
          });
          return;
        },
        enabled: () => bucketName.text.isNotEmpty,
        listenable: bucketName,
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Copy file to another bucket.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Copy To Bucket";
}

class AddTagsFileManager extends MethodWrap {
  AddTagsFileManager();

  final TextEditingController tagsController = TextEditingController();

  final List<String> tagging = [];

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(
        hint: "Tags",
        editingController: tagsController,
        suffixIcon: (c) => IconButton(
            onPressed: () {
              tagging.add(tagsController.text);
              tagsController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.add)),
      ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      if (tagging.isNotEmpty)
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Header('Tags to add', level: 2).doc(context),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  for (var value in tagging)
                    ActionChip(
                      label: Text((value)),
                      onPressed: () {
                        tagging.removeWhere((element) => element == value);
                        setState(() {});
                      },
                    )
                ],
              ),
            ],
          ),
        ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      AltogicButton(
          body: 'Add Tags',
          listenable: tagsController,
          enabled: () => !loading && tagging.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              await FileManagerService.of(context).addTags(tagging);
              tagsController.clear();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Add tags to a file.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Add Tags";
}

class RemoveTagsFileManager extends MethodWrap {
  RemoveTagsFileManager();

  Map<String, dynamic> get file =>
      FileManagerService.of(context).fileInfo.value!;

  late final List<String> tags = (file['tags'] as List).cast<String>();

  final List<String> tagsToRemove = [];

  @override
  List<Widget> children(BuildContext context) {
    return [
      if (tagsToRemove.isNotEmpty)
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Header('Tags to remove', level: 2).doc(context),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  for (var value in tagsToRemove)
                    ActionChip(
                      label: Text((value)),
                      onPressed: () {
                        tagsToRemove.removeWhere((element) => element == value);
                        tags.add(value);
                        setState(() {});
                      },
                    )
                ],
              ),
            ],
          ),
        ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      if (tags.isNotEmpty)
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Header('Current tags', level: 2).doc(context),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  for (var value in tags)
                    ActionChip(
                      label: Text((value)),
                      onPressed: () {
                        tags.removeWhere((element) => element == value);
                        tagsToRemove.add(value);
                        setState(() {});
                      },
                    )
                ],
              ),
            ],
          ),
        ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      AltogicButton(
          body: 'Remove Tags',
          enabled: () => !loading && tagsToRemove.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              await FileManagerService.of(context).removeTags(tagsToRemove);
              tagsToRemove.clear();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Remove tags from a bucket.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Remove Tags";
}

class UpdateInfoFileManager extends MethodWrap {
  UpdateInfoFileManager();

  Map<String, dynamic> get file =>
      FileManagerService.of(context).fileInfo.value!;
  final TextEditingController tagsController = TextEditingController();
  late final TextEditingController newName = TextEditingController(
    text: file['fileName'],
  );
  late final ValueNotifier<bool> isPublic =
      ValueNotifier(file['isPublic'] as bool);

  late final List<String> tagging = (file['tags'] as List).cast<String>();



  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(
        hint: "New Name",
        editingController: newName,
      ),
      AltogicInput(
        hint: "Tags",
        editingController: tagsController,
        suffixIcon: (c) => IconButton(
            onPressed: () {
              tagging.add(tagsController.text);
              tagsController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.add)),
      ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      if (tagging.isNotEmpty)
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Header('Tags', level: 2).doc(context),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  for (var value in tagging)
                    ActionChip(
                      label: Text((value)),
                      onPressed: () {
                        tagging.removeWhere((element) => element == value);
                        setState(() {});
                      },
                    )
                ],
              ),
            ],
          ),
        ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      ValueListenableBuilder(
          valueListenable: isPublic,
          builder: (c, v, w) {
            return SizedBox(
              width: 300,
              child: CheckboxListTile(
                value: v,
                onChanged: (value) {
                  isPublic.value = value ?? false;
                },
                title: const Text('Is Public'),
              ),
            );
          }),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      AltogicButton(
          body: 'Update Info',
          listenable: tagsController,
          enabled: () => !loading,
          onPressed: () {
            asyncWrapper(() async {
              await FileManagerService.of(context).updateInfo(
                tags: tagging,
                isPublic: isPublic.value,
                newName: newName.text.isEmpty ? null : newName.text,
              );
              tagsController.clear();
              newName.clear();

            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Update Info'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Update Info";
}
