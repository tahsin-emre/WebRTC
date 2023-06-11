import 'package:flutter/material.dart';
import 'package:webrtcdemo/vm/home_vm.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget {
  final HomeVM vm = HomeVM();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WebRTC Test'),
      ),
      body: ScreenTypeLayout.builder(
        desktop: (p0) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SizedBox(width: 900, child: mobile(p0))],
        ),
        mobile: (p0) => mobile(p0),
      ),
    );
  }

  Widget mobile(BuildContext p0) {
    return Column();
  }
}
