import 'package:flutter/material.dart';

class CFCLoadingWidget extends StatefulWidget {
  const CFCLoadingWidget({Key? key}) : super(key: key);

  @override
  State<CFCLoadingWidget> createState() => _CFCLoadingWidgetState();
}

class _CFCLoadingWidgetState extends State<CFCLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        ),
        child: Image.asset('assets/cfc_logo_med.png'),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Loading Indicator')),
        body: Center(child: CFCLoadingWidget()),
      ),
    ),
  );
}
