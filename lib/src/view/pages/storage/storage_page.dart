import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/service/storage_service.dart';
import 'package:altogic_flutter_example/src/service/suggestion_service.dart';
import 'package:altogic_flutter_example/src/view/pages/database/cases.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/button.dart';
import 'package:altogic_flutter_example/src/view/widgets/case.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/input.dart';
import 'package:flutter/material.dart';

import '../../widgets/documentation/code.dart';
import '../../widgets/documentation/texts.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final StorageService service = StorageService();

  final widgets = [
    CreateBucket.new,
    ListBuckets.new,
    GetStorageStats.new,
    SearchFilesStorage.new,
    DeleteFileStorage.new,
    CreateBucketManager.new
  ];

  @override
  Widget build(BuildContext context) {
    return InheritedService(
        service: service,
        child: BaseViewer(
          leadingHome: true,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  const Documentation(children: [
                    Header('Storage'),
                    Description(
                        'Storage Manager , Bucket Manager and File Manager'),
                    vSpace,
                  ]),
                  ...widgets.map((e) => MethodWidget(create: e)),
                ],
              ),
            ),
          ),
        ));
  }
}

class BucketCreatingManager {
  List<String> tags = [];
  ValueNotifier<bool> isPublic = ValueNotifier(false);
}

class CreateBucket extends MethodWrap {
  CreateBucket();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final BucketCreatingManager manager = BucketCreatingManager();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(hint: 'Bucket Name', editingController: nameController),
      AltogicInput(
        editingController: tagController,
        hint: "Tags",
        suffixIcon: (c) => IconButton(
            onPressed: tagController.text.isEmpty
                ? null
                : () {
                    manager.tags.add(tagController.text);
                    tagController.clear();
                    setState(() {});
                  },
            icon: const Icon(Icons.add)),
      ),
      ValueListenableBuilder(
          valueListenable: manager.isPublic,
          builder: (context, value, child) {
            return Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 200,
                child: CheckboxListTile(
                  title: const Text('Is Public'),
                  value: value,
                  onChanged: (value) {
                    manager.isPublic.value = value!;
                  },
                ),
              ),
            );
          }),
      Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [...manager.tags.map((e) => Chip(label: Text(e)))],
        ),
      ),
      AltogicButton(
        listenable: nameController,
        enabled: () => nameController.text.isNotEmpty,
        onPressed: () {
          asyncWrapper(() async {
            await StorageService.of(context).createBucket(
                nameController.text, manager.tags, manager.isPublic.value);
          });
        },
        body: 'Create Bucket',
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const Description('Create a new bucket'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => (c) => [
            const Description('Create a new bucket'),
            vSpace,
            DartCode('''
final res = await altogic.storage.createBucket(
  "${nameController.text}",
  isPublic: ${manager.isPublic.value},
  tags: [${manager.tags.map((e) => '"$e"').join(', ')}]
);
'''),
          ];

  @override
  String get name => "Create Bucket";
}

class FilterBucketService {
  List<BucketSortField> fields = BucketSortField.values;

  ValueNotifier<BucketSortField> currentField =
      ValueNotifier(BucketSortField.createdAt);

  ValueNotifier<bool> asc = ValueNotifier(true);

  ValueNotifier<bool> returnCount = ValueNotifier(false);
}

class ListBuckets extends MethodWrap {
  final TextEditingController limitController = TextEditingController(
    text: '10',
  );
  final TextEditingController pageController = TextEditingController(
    text: '1',
  );

  final FilterBucketService filter = FilterBucketService();

  ListBuckets();

  final TextEditingController expressionController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
    var sorting = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Sorting With:'),
        ValueListenableBuilder(
            valueListenable: filter.currentField,
            builder: (context, value, child) {
              return DropdownButton<BucketSortField>(
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
          hint: 'Filter Expression (optional)',
          editingController: expressionController),

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
          body: 'List Buckets',
          listenable: Listenable.merge([
            limitController,
            pageController,
          ]),
          enabled: () =>
              !loading &&
              int.tryParse(limitController.text) != null &&
              int.tryParse(pageController.text) != null,
          onPressed: () {
            asyncWrapper(() async {
              await StorageService.of(context).listBucket(
                expression: expressionController.text.isNotEmpty
                    ? expressionController.text
                    : null,
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
        const Description('List buckets'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "List Buckets";
}

class GetStorageStats extends MethodWrap {
  GetStorageStats();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicButton(
        body: 'Get Storage Stats',
        onPressed: () {
          asyncWrapper(() async {
            await StorageService.of(context).getStats();
          });
        },
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [const AutoSpan("Get Stats")];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Get Stats";
}

class SearchFileStorageService {
  List<FileSortField> fields = FileSortField.values;

  ValueNotifier<FileSortField> currentField =
      ValueNotifier(FileSortField.updatedAt);

  ValueNotifier<bool> asc = ValueNotifier(true);

  ValueNotifier<bool> returnCount = ValueNotifier(false);
}

class SearchFilesStorage extends MethodWrap {
  final TextEditingController limitController = TextEditingController(
    text: '10',
  );
  final TextEditingController pageController = TextEditingController(
    text: '1',
  );

  final SearchFileStorageService filter = SearchFileStorageService();

  SearchFilesStorage();

  final TextEditingController expressionController = TextEditingController();

  @override
  List<Widget> children(BuildContext context) {
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
          body: 'List Buckets',
          listenable: Listenable.merge(
              [limitController, pageController, expressionController]),
          enabled: () =>
              !loading &&
              int.tryParse(limitController.text) != null &&
              int.tryParse(pageController.text) != null &&
              expressionController.text.isNotEmpty,
          onPressed: () {
            asyncWrapper(() async {
              await StorageService.of(context).searchFilesStorage(
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
        const Description('Search File in all buckets'),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Search File";
}

class DeleteFileStorage extends MethodWrap {
  DeleteFileStorage();

  final TextEditingController urlController = TextEditingController();

  final ValueNotifier<String?> preview = ValueNotifier<String?>(null);

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(
        editingController: urlController,
        hint: 'File URL',
      ),
      vSpace.doc(context),
      Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: SizedBox(
          width: 500,
          child: ValueListenableBuilder(
              valueListenable: preview,
              builder: (c, v, w) {
                return v == null ? Container() : Image.network(v);
              }),
        ),
      ),
      AltogicButton(
          listenable: urlController,
          enabled: () => !loading && urlController.text.isNotEmpty,
          body: "Preview Image",
          onPressed: () {
            setState(() {
              preview.value = urlController.text;
            });
          }),
      AltogicButton(
        body: 'Delete File',
        onPressed: () {
          asyncWrapper(() async {
            await StorageService.of(context).deleteFile(urlController.text);
          });
        },
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Delete File With URL (publicPath)"),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Delete File (with url)";
}

class CreateBucketManager extends MethodWrap {
  CreateBucketManager();

  final TextEditingController nameOrIdController = TextEditingController();

  final SuggestionService suggestionService = SuggestionService();

  @override
  List<Widget> children(BuildContext context) {
    return [
      AltogicInput(
          hint: "Bucket Name Or ID", editingController: nameOrIdController),
      vSpace.doc(context),
      ...suggestionService.getWidget(
          context,
          (limit, page) async {
            var res = await StorageService.of(context).listBucket(
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
            nameOrIdController.text = id;
          }),
      vSpace.doc(context),
      AltogicButton(
          body: "Get Suggestions",
          onPressed: () {
            asyncWrapper(() async {
              suggestionService.page = 1;
              var res = await StorageService.of(context).listBucket(
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
        body: "Create BucketManager",
        onPressed: () {
          Navigator.of(context).pushNamed('/bucket',
              arguments: <String, dynamic>{'bucket': nameOrIdController.text});
          return;
        },
        enabled: () => nameOrIdController.text.isNotEmpty,
        listenable: nameOrIdController,
      )
    ];
  }

  @override
  List<DocumentationObject> get description => [
        const AutoSpan("Create BucketManager to manage the bucket."),
      ];

  @override
  List<DocumentationObject> Function(BuildContext context)?
      get documentationBuilder => null;

  @override
  String get name => "Create BucketManager";
}
