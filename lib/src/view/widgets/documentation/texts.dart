import 'dart:collection';

import 'package:altogic_flutter_example/src/view/widgets/documentation/base.dart';
import 'package:flutter/material.dart';

class Header extends DocTextMixin {
  const Header(super.text, {this.level = 1});

  final int level;

  static final _fontSizes = <double>[-1, 30, 20, 15, 10];

  @override
  TextStyle get style =>
      TextStyle(fontSize: _fontSizes[level], fontWeight: FontWeight.bold);
}

class Description extends DocTextMixin {
  const Description(super.text);

  @override
  TextStyle get style => const TextStyle(
        color: Colors.black,
        fontSize: 15,
      );
}

class Bold extends DocTextMixin {
  const Bold(super.text);

  @override
  TextStyle get style => const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );
}

class Italic extends DocTextMixin {
  const Italic(super.text);

  @override
  TextStyle get style => const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );
}

class InlineCode extends DocTextMixin {
  const InlineCode(String text) : super(text);

  @override
  TextStyle get style => TextStyle(
      color: Colors.white,
      fontFamily: 'Code',
      decorationThickness: 10,
      letterSpacing: 1,
      background: Paint()..color = Colors.black26);
}

class DocTextSpan extends DocumentationObject {
  const DocTextSpan({Key? key, required this.children}) : super();

  final List<DocTextMixin> children;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: children
                .map((e) => TextSpan(text: e.text, style: e.style))
                .toList()));
  }
}

class LeftSpace extends DocumentationObject {
  const LeftSpace(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 0,
            width: 20,
            left: 0,
            child: Container(
              color: Colors.black26.withOpacity(0.05),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: AutoSpan(text).doc(context),
        )
      ],
    );
  }
}

class AutoSpan extends DocumentationObject {
  const AutoSpan(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    var boldRegex = RegExp(r'(\*)(.*?)(\*)');
    var italicRegex = RegExp(r'(\/)(.*?)(\/)');
    var codeRegex = RegExp(r'(\`)(.*?)(\`)');

    var splay = SplayTreeMap<int, Match>();

    splay.addAll(boldRegex
        .allMatches(text)
        .toList()
        .asMap()
        .map((key, value) => MapEntry(value.start, value)));
    splay.addAll(italicRegex
        .allMatches(text)
        .toList()
        .asMap()
        .map((key, value) => MapEntry(value.start, value)));
    splay.addAll(codeRegex
        .allMatches(text)
        .toList()
        .asMap()
        .map((key, value) => MapEntry(value.start, value)));

    if (splay.isEmpty) {
      return Description(text).doc(context);
    }

    var span = <DocTextMixin>[];

    var last = 0;
    var f = splay.firstKey()!;
    span.add(Description(text.substring(last, splay[f]!.start)));
    last = splay[f]!.end;
    while (splay.isNotEmpty) {
      var first = splay.firstKey()!;
      var match = splay[first]!;
      var sub = text.substring(match.start, match.end);
      if (sub.startsWith('*')) {
        span.add(Bold(sub.substring(1, sub.length - 1)));
      } else if (sub.startsWith('/')) {
        span.add(Italic(sub.substring(1, sub.length - 1)));
      } else if (sub.startsWith('`')) {
        span.add(InlineCode(sub.substring(1, sub.length - 1)));
      }

      last = match.end;
      splay.remove(first);
      span.add(Description(text.substring(last, splay.firstKey())));
    }

    return DocTextSpan(children: span).doc(context);
  }
}
