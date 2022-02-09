import 'package:flutter/material.dart';

class DearTIconButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Future<bool> Function() onTap;
  const DearTIconButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  State<DearTIconButton> createState() => _DearTIconButtonState();
}

class _DearTIconButtonState extends State<DearTIconButton> {
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
            onTap: runAction,
            child: Center(
              child: SizedBox.fromSize(
                size: const Size(80, 80), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          widget.icon,
                          size: 36,
                        ), // icon
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future runAction() async {
    Future<bool> task = widget.onTap();

    setState(() {
      isRunning = true;
    });

    await task;

    setState(() {
      isRunning = false;
    });
  }
}
