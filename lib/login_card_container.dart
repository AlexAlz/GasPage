import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        //height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Colors.black54, blurRadius: 20, offset: Offset(0, 5)),
          ],
        ),
        child: child,
      ),
    );
  }
}
