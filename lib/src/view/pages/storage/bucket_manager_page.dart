import 'dart:convert';

import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/service/storage_service.dart';
import 'package:altogic_flutter_example/src/view/widgets/base_viewer.dart';
import 'package:altogic_flutter_example/src/view/widgets/case.dart';
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

  @override
  void initState() {
    bucketService.getBucketInfo();
    super.initState();
  }

  Map<String, dynamic> get bucket => bucketService.bucketInfo.value!;

  @override
  Widget build(BuildContext context) {
    return InheritedService(
      service: bucketService,
      child: BaseViewer(
        leadingHome: !Navigator.canPop(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 30,
          ),
          child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: bucketService.bucketInfo,
                  builder: (context, v, w) {
                    return Documentation(children: [
                      const Header("Bucket Manager"),
                      AutoSpan("Bucket : ${widget.bucket}"),
                      vSpace,
                      if (v != null)
                        Description(
                            'Bucket Info : \n${const JsonEncoder.withIndent('   ').convert(bucket)}')
                      else
                        const AutoSpan(
                            'There is no bucket with this name or ID'),
                      vSpace,
                    ]);
                  }),
              ...[
                GetBucketExists.new,
                GetBucketInfo.new,
                EmptyBucket.new,
                RenameBucket.new,
                DeleteBucket.new,
                MakePublicBucket.new,
                MakePrivateBucket.new,
                ListFilesBucket.new,
                UploadFileFromBucket.new,
                DeleteFilesMethod.new,
              ].map((e) => MethodWidget(
                    create: e,
                    response: bucketService.response,
                  )),
              ValueListenableBuilder(
                  valueListenable: bucketService.bucketInfo,
                  builder: (context, v, w) {
                    return v != null
                        ? Column(
                            children: [
                              AddTagsBucketManager.new,
                              RemoveTagsBucketManager.new,
                              UpdateInfoBucketManager.new,
                            ]
                                .map((e) => MethodWidget(
                                      create: e,
                                      response: bucketService.response,
                                    ))
                                .toList(),
                          )
                        : const SizedBox();
                  }),
              MethodWidget(
                create: CreateFileManager.new,
                response: bucketService.response,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
