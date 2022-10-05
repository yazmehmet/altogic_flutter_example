import 'package:flutter/material.dart';

class Documentation extends StatelessWidget {
  const Documentation({Key? key, required this.children}) : super(key: key);

  final List<DocumentationObject> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final child in children) ...[
            child.build(context),
          ],
        ],
      ),
    );
  }
}

abstract class DocumentationObject {
  const DocumentationObject();

  Widget build(BuildContext context);

  Widget doc(BuildContext context) {
    return Documentation(children: [this]);
  }
}

class ImageDoc extends DocumentationObject {
  const ImageDoc(this.path);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.network(path);
  }
}

const VerticalSpace vSpace = VerticalSpace();

class VerticalSpace extends DocumentationObject {
  const VerticalSpace();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class DocWidget extends DocumentationObject {
  const DocWidget({required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

abstract class DocTextMixin extends DocumentationObject {
  const DocTextMixin(this.text);

  final String text;

  TextStyle get style;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: style,
    );
  }
}
