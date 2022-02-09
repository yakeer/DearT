import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class DearTElevatedButtton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool? disabled;
  final Future<dynamic> Function() onPressed;
  final String? longPressPopupTitle;
  final String? longPressPopupMessage;

  const DearTElevatedButtton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.disabled,
    this.longPressPopupTitle,
    this.longPressPopupMessage,
  }) : super(key: key);

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
            onLongPress: widget.longPressPopupMessage != null
                ? () => openPopup(
                      widget.longPressPopupTitle ?? widget.label,
                      widget.longPressPopupMessage!,
                    )
                : null,
            icon: widget.icon != null ? Icon(widget.icon) : Container(),
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.label),
            ),
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
