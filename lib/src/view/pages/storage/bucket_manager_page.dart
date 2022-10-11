import 'dart:convert';

import 'package:altogic_flutter_example/main.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/service/storage_service.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:altogic_flutter_example/src/view/widgets/documentation/texts.dart';
import 'package:flutter/material.dart';

import 'bucket_cases.dart';

class BucketManagerPage extends StatefulWidget {
  const BucketManagerPage({Key? key, required this.bucket}) : super(key: key);

  final String bucket;

  @override
  State<BucketManagerPage> createState() => _BucketManagerPageState();
}

class _BucketManagerPageState extends State<BucketManagerPage> {
  late BucketService bucketService = BucketService(bucket: widget.bucket);

  List<Widget> widgets = [
    GetBucketExists(),
    GetBucketInfo(),
    EmptyBucket(),
    RenameBucket(),
    DeleteBucket(),
    MakePublicBucket(),
    MakePrivateBucket(),
    ListFilesBucket(),
    UploadFileFromBucket(),
    DeleteFilesMethod(),
  ];

  @override
  void initState() {
    _getBucket();
    super.initState();
  }

  Map<String, dynamic>? bucket;
  bool loaded = false;

  Future<void> _getBucket() async {
    var bucket = await altogic.storage.bucket(widget.bucket).getInfo();
    setState(() {
      loaded = true;
      this.bucket = bucket.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedService(
      service: bucketService,
      child: BaseViewer(
        leadingHome: !Navigator.canPop(context),
        body: Center(
          child: Column(
            children: [
              Documentation(children: [
                const Header("Bucket Manager"),
                AutoSpan("Bucket : ${widget.bucket}"),
                vSpace,
                if (loaded)
                  if (bucket != null)
                    AutoSpan(
                        'Bucket Info : \n${const JsonEncoder.withIndent('   ').convert(bucket)}')
                  else
                    const AutoSpan('There is no bucket with this name or ID'),
                vSpace,
              ]),
              ...widgets,
              if (bucket != null) ...[
                AddTagsBucketManager(onAdd: _getBucket),
                RemoveTagsBucketManager(
                  tags: (bucket!['tags'] as List).cast<String>(),
                  onRemove: _getBucket,
                ),
                UpdateInfoBucketManager(bucket: bucket!, onUpdate: _getBucket)
              ],
            ],
          ),
        ),
      ),
    );
  }
}
