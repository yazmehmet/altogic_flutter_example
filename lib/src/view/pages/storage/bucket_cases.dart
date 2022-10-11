import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/src/service/suggestion_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'utils/upload.dart'
    if (dart.library.io) 'utils/io_upload.dart'
    if (dart.library.html) 'utils/web_upload.dart' show getUintList;

import '../../../service/storage_service.dart';
import '../../widgets/button.dart';
import '../../widgets/case.dart';
import '../../widgets/documentation/base.dart';
import '../../widgets/documentation/texts.dart';
import '../../widgets/input.dart';
import 'storage_page.dart';

class GetBucketExists extends MethodWrap {
  GetBucketExists({super.key});

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicButton(
          body: "Get Bucket Exists",
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).getBucketExists();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Get bucket exists"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Get Bucket exists";
}

class GetBucketInfo extends MethodWrap {
  GetBucketInfo({super.key});

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicButton(
          body: "Get Bucket Info",
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).getBucketInfo();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Get bucket info"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Get Bucket Info";
}

class EmptyBucket extends MethodWrap {
  EmptyBucket({super.key});

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicButton(
          body: "Empty Bucket (clear bucket)",
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).emptyBucket();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Empty Bucket"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Empty Bucket";
}

class RenameBucket extends MethodWrap {
  RenameBucket({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(hint: "New Name", editingController: controller),
      AltogicButton(
          body: "Rename Bucket",
          enabled: () => controller.text.isNotEmpty,
          listenable: controller,
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).renameBucket(controller.text);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Rename Bucket"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Rename Bucket";
}

class DeleteBucket extends MethodWrap {
  DeleteBucket({super.key});

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicButton(
          body: "Delete Bucket",
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).deleteBucket();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Delete Bucket"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Delete Bucket";
}

class MakePublicBucket extends MethodWrap {
  MakePublicBucket({super.key});

  final ValueNotifier<bool> includeFiles = ValueNotifier(false);

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      SizedBox(
        width: 250,
        child: ValueListenableBuilder<bool>(
          valueListenable: includeFiles,
          builder: (context, value, child) => Row(
            children: [
              const Expanded(child: Text("Include Files")),
              Switch(
                value: value,
                onChanged: (value) => includeFiles.value = value,
              ),
            ],
          ),
        ),
      ),
      vSpace.doc(context),
      AltogicButton(
          body: "Make Public",
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).makePublic(includeFiles.value);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Make Public"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Make Public";
}

class MakePrivateBucket extends MethodWrap {
  MakePrivateBucket({super.key});

  final ValueNotifier<bool> includeFiles = ValueNotifier(false);

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      SizedBox(
        width: 250,
        child: ValueListenableBuilder<bool>(
          valueListenable: includeFiles,
          builder: (context, value, child) => Row(
            children: [
              const Expanded(child: Text("Include Files")),
              Switch(
                value: value,
                onChanged: (value) => includeFiles.value = value,
              ),
            ],
          ),
        ),
      ),
      vSpace.doc(context),
      AltogicButton(
          body: "Make Private",
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).makePrivate(includeFiles.value);
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Make Private"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Make Private";
}

class ListFilesBucket extends MethodWrap {
  final TextEditingController limitController = TextEditingController(
    text: '10',
  );
  final TextEditingController pageController = TextEditingController(
    text: '1',
  );

  final SearchFileStorageService filter = SearchFileStorageService();

  ListFilesBucket({super.key});

  final TextEditingController expressionController = TextEditingController();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    var sorting = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Sorting With:'),
        ValueListenableBuilder(
            valueListenable: filter.currentField,
            builder: (context, value, child) {
              return DropdownButton<FileSortField>(
                  value: filter.currentField.value,
                  items: filter.fields
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      filter.currentField.value = v!;
                    });
                  });
            }),
        const SizedBox(
          width: 20,
        ),
        ValueListenableBuilder(
            valueListenable: filter.asc,
            builder: (context, val, w) {
              return SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Ascending'),
                    Switch(
                        value: val,
                        onChanged: (v) {
                          setState(() {
                            filter.asc.value = v;
                          });
                        }),
                  ],
                ),
              );
            }),
      ],
    );
    var size = MediaQuery.of(context).size;
    return [
      // Sort with
      Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: SizedBox(
            width: MediaQuery.of(context).size.width.clamp(0, 500),
            child: size.width < 350
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: sorting,
                  )
                : sorting),
      ),
      ValueListenableBuilder(
          valueListenable: filter.returnCount,
          builder: (context, value, child) {
            return Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 250,
                child: CheckboxListTile(
                  title: const Text('Return Count Info'),
                  value: value,
                  onChanged: (value) {
                    filter.returnCount.value = value!;
                  },
                ),
              ),
            );
          }),
      vSpace.doc(context),

      AltogicInput(
          hint: 'Filter Expression', editingController: expressionController),

      // Limit
      AltogicInput(
        editingController: limitController,
        hint: 'Limit',
        info: const [
          AutoSpan('Limit is used to limit the number of results.'),
          vSpace,
          AutoSpan('Default value is 10.'),
        ],
      ),

      // Page
      AltogicInput(
        editingController: pageController,
        hint: 'Page',
        info: const [
          AutoSpan('Page is used to get the next page of results.'),
          vSpace,
          AutoSpan('Default value is 1.'),
        ],
      ),

      AltogicButton(
          body: 'List Files',
          listenable: Listenable.merge([limitController, pageController]),
          enabled: () =>
              !loading &&
              int.tryParse(limitController.text) != null &&
              int.tryParse(pageController.text) != null,
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).listFiles(
                expression: expressionController.text,
                limit: int.parse(limitController.text),
                page: int.parse(pageController.text),
                returnCountInfo: filter.returnCount.value,
                sort: filter.currentField.value,
                asc: filter.asc.value,
              );
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('List Files in the bucket.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "List Files.";
}

class UploadFileFromBucket extends MethodWrap {
  UploadFileFromBucket({super.key});

  final ValueNotifier<PlatformFile?> bytes = ValueNotifier<PlatformFile?>(null);
  final TextEditingController nameController = TextEditingController();
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
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
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
                          child: AltogicInput(
                              hint: "File Name",
                              editingController: nameController),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              nameController.clear();
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
                    nameController.text = file.files.first.name;
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
      AltogicButton(
          enabled: () =>
              !loading && bytes.value != null && nameController.text.isNotEmpty,
          body: 'Upload File',
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context)
                  .uploadFile(nameController.text, getUintList(bytes.value!),
                      (l, t, percent) {
                process.value = t / l;
              },
                      bytes.value!.extension != null
                          ? contentTypes[bytes.value!.extension]!
                          : 'text/plain');

              process.value = null;
              bytes.value = null;
              nameController.clear();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Upload a file to the bucket.'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Upload File";
}

class _Deleting {
  final List<String> deleting = [];
  int page = 0;
}

class DeleteFilesMethod extends MethodWrap {
  DeleteFilesMethod({super.key});

  final SuggestionService suggestionService = SuggestionService();

  final TextEditingController nameOrIdController = TextEditingController();

  final _Deleting _deleting = _Deleting();

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
    return [
      AltogicInput(
        hint: "File Name Or ID",
        editingController: nameOrIdController,
        suffixIcon: (c) => IconButton(
            onPressed: () {
              suggestionService.values.removeWhere((element) =>
                  element["_id"] == nameOrIdController.text ||
                  element["fileName"] == nameOrIdController.text);
              _deleting.deleting.add(nameOrIdController.text);
              nameOrIdController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.add)),
      ),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      if (_deleting.deleting.isNotEmpty)
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Header('Files to delete', level: 2).doc(context),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  for (var value in _deleting.deleting)
                    ActionChip(
                      label: Text((value)),
                      onPressed: () {
                        _deleting.deleting
                            .removeWhere((element) => element == value);
                        suggestionService.values.removeWhere((element) =>
                            element["_id"] == value ||
                            element["fileName"] == value);
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
      ...suggestionService.getWidget(
          context,
          (limit, page) async {
            var res = await BucketService.of(context).listFiles(
                limit: limit,
                page: page,
                returnCountInfo: false,
                sort: FileSortField.fileName,
                asc: true,
                expression: '');
            return (res as List)
                .map((e) => (e as Map).cast<String, dynamic>())
                .toList();
          },
          (map) => map['fileName'],
          setState,
          (id) {
            var w = suggestionService.values
                .indexWhere((element) => element["_id"] == id);
            if (w != -1) {
              _deleting.deleting.add(suggestionService.values[w]["fileName"]);
              suggestionService.values.removeAt(w);
            }
          }),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      AltogicButton(
          body: 'Get Suggestions',
          onPressed: () {
            suggestionService.getSuggestions((limit, page) async {
              var res = await BucketService.of(context).listFiles(
                  limit: limit,
                  page: page,
                  returnCountInfo: false,
                  sort: FileSortField.fileName,
                  asc: true,
                  expression: '');
              return (res as List)
                  .map((e) => (e as Map).cast<String, dynamic>())
                  .toList();
            }, setState);
          }),
      AltogicButton(
          body: 'Delete Files',
          listenable: nameOrIdController,
          enabled: () => !loading && _deleting.deleting.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).deleteFiles(_deleting.deleting);
              _deleting.deleting.clear();
            });
          })
    ];
  }

  @override
  List<DocumentationObject> get description => [const AutoSpan("Delete Files")];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Delete Files";
}

class AddTagsBucketManager extends MethodWrap {
  AddTagsBucketManager({super.key, required this.onAdd});

  final TextEditingController tagsController = TextEditingController();

  final List<String> tagging = [];

  final VoidCallback onAdd;

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
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
              await BucketService.of(context).addTags(tagging);
              tagsController.clear();
              onAdd();
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

class RemoveTagsBucketManager extends MethodWrap {
  RemoveTagsBucketManager(
      {super.key, required this.tags, required this.onRemove});

  final List<String> tags;

  final List<String> tagsToRemove = [];

  final VoidCallback onRemove;

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
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
              await BucketService.of(context).removeTags(tagsToRemove);
              tagsToRemove.clear();
              onRemove();
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

class UpdateInfoBucketManager extends MethodWrap {
  UpdateInfoBucketManager(
      {super.key, required this.bucket, required this.onUpdate});

  final Map<String, dynamic> bucket;
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController newName = TextEditingController();
  late final ValueNotifier<bool> isPublic =
      ValueNotifier(bucket['isPublic'] as bool);
  final ValueNotifier<bool> includeFiles = ValueNotifier(false);

  final List<String> tagging = [];

  final VoidCallback onUpdate;

  @override
  List<Widget> children(
      BuildContext context, void Function(void Function() p1) setState) {
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
                title: const Text('Include Files'),
              ),
            );
          }),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      AltogicButton(
          body: 'Update Info',
          listenable: tagsController,
          enabled: () => !loading && tagging.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              await BucketService.of(context).updateInfo(
                tags: tagging,
                includeFiles: includeFiles.value,
                isPublic: isPublic.value,
                newName: newName.text.isEmpty ? null : newName.text,
              );
              tagsController.clear();
              newName.clear();
              onUpdate();
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
