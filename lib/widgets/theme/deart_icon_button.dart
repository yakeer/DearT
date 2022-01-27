import 'package:flutter/material.dart';

class DearTIconButtton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onTap;
  const DearTIconButtton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                    icon,
                    size: 36,
                  ), // icon
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      label,
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
}
