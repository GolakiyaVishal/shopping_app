import 'package:flutter/material.dart';

class SmallLoader extends StatelessWidget {
  const SmallLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
      ),
    );
  }
}
