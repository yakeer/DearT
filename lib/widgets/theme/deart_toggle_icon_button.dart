import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DearTToggleIconButton extends StatefulWidget {
  final String onLabel;
  final String offLabel;
  final String? unknownLabel;
  final IconData icon;
  final Future<bool> Function() onStateTap;
  final Future<bool> Function() offStateTap;
  final Future<bool> Function()? unknownStateTap;
  final DearTToggleIconButtonState toggleState;
  final bool showBadge;
  final bool disabled;

  const DearTToggleIconButton({
    Key? key,
    required this.onLabel,
    required this.offLabel,
    this.unknownLabel,
    required this.icon,
    required this.onStateTap,
    required this.offStateTap,
    this.unknownStateTap,
    required this.toggleState,
    this.showBadge = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<DearTToggleIconButton> createState() => _DearTToggleIconButtonState();
}

class _DearTToggleIconButtonState extends State<DearTToggleIconButton> {
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return isRunning
        ? const SizedBox(
            width: 80,
            height: 80,
            child: Padding(
              padding: EdgeInsets.all(28.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : InkWell(
            onTap: !widget.disabled ? runAction : null,
            child: Opacity(
              opacity: widget.disabled ? 0.25 : 1,
              child: Center(
                child: SizedBox.fromSize(
                  size: const Size(80, 80), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                widget.icon,
                                size: 36,
                                color: _getColorByState(),
                              ), // icon
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.disabled ? '' : getLabelByState(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getColorByState(),
                                  ),
                                ),
                              ), // text
                            ],
                          ),
                          Visibility(
                            visible: widget.showBadge,
                            child: Positioned.fill(
                              bottom: 10,
                              right: 20,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _getColorByState(),
                                      ),
                                      color: _getColorByState(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        getStateText(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future runAction() async {
    Future<bool> task = getActionByState()();

    setState(() {
      isRunning = true;
    });

    await task;

    setState(() {
      isRunning = false;
    });
  }

  String getStateText() {
    switch (widget.toggleState) {
      case DearTToggleIconButtonState.on:
        return 'On';
      case DearTToggleIconButtonState.off:
        return 'Off';
      case DearTToggleIconButtonState.unknown:
        return '?';
    }
  }

  Future<bool> Function() getActionByState() {
    switch (widget.toggleState) {
      case DearTToggleIconButtonState.on:
        return widget.onStateTap;
      case DearTToggleIconButtonState.off:
        return widget.offStateTap;
      case DearTToggleIconButtonState.unknown:
        return widget.unknownStateTap!;
    }
  }

  String getLabelByState() {
    switch (widget.toggleState) {
      case DearTToggleIconButtonState.on:
        return widget.onLabel;
      case DearTToggleIconButtonState.off:
        return widget.offLabel;
      case DearTToggleIconButtonState.unknown:
        return widget.unknownLabel!;
    }
  }

  Color _getColorByState() {
    switch (widget.toggleState) {
      case DearTToggleIconButtonState.on:
        return Get.theme.buttonTheme.colorScheme?.secondary ?? Colors.lightBlue;
      case DearTToggleIconButtonState.off:
        return Colors.white;
      case DearTToggleIconButtonState.unknown:
        return Colors.white;
    }
  }
}

enum DearTToggleIconButtonState {
  on,
  off,
  unknown,
}
