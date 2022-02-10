import 'package:flutter/material.dart';

class DearTHeaterButton extends StatefulWidget {
  final void Function()? onPressed;
  final bool isBinary;
  final dynamic heaterValue;
  final Icon? icon;

  const DearTHeaterButton({
    Key? key,
    this.onPressed,
    this.isBinary = false,
    this.heaterValue,
    this.icon,
  }) : super(key: key);

  @override
  _DearTHeaterButtonState createState() => _DearTHeaterButtonState();
}

class _DearTHeaterButtonState extends State<DearTHeaterButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            return _getBackgroundColor();
          },
        ),
      ),
      onPressed: widget.onPressed,
      child: Icon(
        _getIcon().icon,
        color: Colors.white,
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isBinary) {
      if (widget.heaterValue == true) {
        return Colors.red.shade800;
      } else {
        return Colors.transparent;
      }
    } else {
      if (widget.heaterValue == 0) {
        return Colors.transparent;
      } else if (widget.heaterValue == 1) {
        return Colors.red.shade200;
      } else if (widget.heaterValue == 2) {
        return Colors.red.shade400;
      } else if (widget.heaterValue == 3) {
        return Colors.red.shade800;
      } else {
        return Colors.transparent;
      }
    }
  }

  Icon _getIcon() {
    return widget.icon!;
  }

  // Widget _getButtonLabel() {
  //   if (widget.isBinary) {
  //     if (widget.heaterValue == true) {
  //       return const Text(
  //         'On',
  //         style: TextStyle(color: Colors.white),
  //       );
  //     } else {
  //       return const Text(
  //         'Off',
  //         style: TextStyle(color: Colors.white),
  //       );
  //     }
  //   } else {
  //     if (widget.heaterValue == 0) {
  //       return const Text(
  //         'Off',
  //         style: TextStyle(color: Colors.white),
  //       );
  //     } else if (widget.heaterValue == 1) {
  //       return const Text(
  //         'Low',
  //         style: TextStyle(color: Colors.white),
  //       );
  //     } else if (widget.heaterValue == 2) {
  //       return const Text(
  //         'Med',
  //         style: TextStyle(color: Colors.white),
  //       );
  //     } else if (widget.heaterValue == 3) {
  //       return const Text(
  //         'High',
  //         style: TextStyle(color: Colors.white),
  //       );
  //     } else {
  //       return const Text('N/A');
  //     }
  //   }
  // }
}
