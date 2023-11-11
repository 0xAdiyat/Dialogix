import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userStateProvider)!;
    return Scaffold(
      body: Center(child: Text(user.name)),
    );
  }
}
