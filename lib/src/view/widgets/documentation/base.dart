import 'package:flutter/gestures.dart';
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
  const ImageDoc(this.path,
      {this.maxWidth,
      this.padding = const EdgeInsets.symmetric(horizontal: 16)});

  final String path;
  final EdgeInsets padding;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Image.network(path, width: maxWidth, fit: BoxFit.cover),
    );
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

  GestureRecognizer? get gesture => null;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: style,
    );
  }
}
