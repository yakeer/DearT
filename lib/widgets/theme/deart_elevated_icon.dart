import 'package:flutter/material.dart';

class DearTElevatedButtton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool? disabled;
  final Future<dynamic> Function() onPressed;
  const DearTElevatedButtton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.onPressed,
      this.disabled})
      : super(key: key);

  @override
  State<DearTElevatedButtton> createState() => _DearTElevatedButttonState();
}

class _DearTElevatedButttonState extends State<DearTElevatedButtton> {
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return isRunning
        ? const ElevatedButton(
            onPressed: null,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          )
        : ElevatedButton.icon(
            onPressed: widget.disabled == null ||
                    (widget.disabled != null && !widget.disabled!)
                ? runAction
                : null,
            icon: widget.icon != null ? Icon(widget.icon) : Container(),
            label: Text(widget.label),
          );
  }

  Future runAction() async {
    Future<dynamic> task = widget.onPressed();

    setState(() {
      isRunning = true;
    });

    await task;

    if (mounted) {
      setState(() {
        isRunning = false;
      });
    }
  }
}
