import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isLoading;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }
}
