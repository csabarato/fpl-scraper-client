import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Color.fromRGBO(56, 4, 60, 1), // Set the border color
          width: 2.0, // You can adjust the border thickness here
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
        ),
        minimumSize: const Size(100, 55)
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromRGBO(56, 4, 60, 1), // Text color matches the border
        ),
      ),
    );
  }
}