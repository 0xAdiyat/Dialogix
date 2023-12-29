import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Error Screen"),
        ),
        body: const Center(
          child: Text("No such post exist or the post has been deleted"),
        ));
  }
}
