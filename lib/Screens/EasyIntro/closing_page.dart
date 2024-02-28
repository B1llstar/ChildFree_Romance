import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confetti Example',
      home: ClosingPage(),
    );
  }
}

class ClosingPage extends StatefulWidget {
  @override
  _ClosingPageState createState() => _ClosingPageState();
}

class _ClosingPageState extends State<ClosingPage> {
  ConfettiController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 1));
    Future.delayed(Duration(milliseconds: 500), () {
      shootConfetti();
    });
  }

  void shootConfetti() {
    _controller!.play();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confetti Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: _controller!,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.20,
              numberOfParticles: 20,
              blastDirection: -3.14 / 2,
            ),
            SizedBox(height: 20),
            Text(
              "You're all set!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Join our official Discord Server for the latest updates!",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shootConfetti();
              },
              child: Text('Shoot Confetti'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
