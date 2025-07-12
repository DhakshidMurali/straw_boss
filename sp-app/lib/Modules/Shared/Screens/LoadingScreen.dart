import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6FD),
      body: Center(
        child: Container(
          child: Lottie.asset(
            'assets/animation/loading.json',
          ),
        ),
      ),
    );
  }
}
