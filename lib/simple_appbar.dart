import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  final String title;

  const SimpleAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 58, 123, 213),
              Color.fromARGB(255, 0, 191, 255),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ]),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 26.0),
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }
}
