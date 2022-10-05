import 'package:flutter/material.dart';

import 'documentation/base.dart';

class AltogicInput extends StatefulWidget {
  const AltogicInput(
      {Key? key,
      required this.hint,
      required this.editingController,
      this.info,
      this.suffixIcon})
      : super(key: key);

  final String hint;
  final TextEditingController editingController;
  final List<DocumentationObject>? info;
  final WidgetBuilder? suffixIcon;

  @override
  State<AltogicInput> createState() => _AltogicInputState();
}

class _AltogicInputState extends State<AltogicInput> {
  @override
  Widget build(BuildContext context) {
    var info = widget.info != null
        ? IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  children: [
                    SimpleDialogOption(
                      child: Documentation(children: widget.info!),
                    )
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info),
          )
        : null;

    return Container(
      width: double.infinity,
      height: 50,
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      child: TextField(
        onChanged: widget.suffixIcon != null ? (value) {
          setState(() {});
        } : null,
        controller: widget.editingController,
        decoration: InputDecoration(
          label: Text(widget.hint),
          suffixIcon: widget.suffixIcon != null && info != null
              ? SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [widget.suffixIcon!(context), info],
                  ),
                )
              : widget.suffixIcon?.call(context) ?? info,
          border: const OutlineInputBorder(),
          hintText: widget.hint,
        ),
      ),
    );
  }
}
