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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: 500,
            child: Card(
              elevation: 2,
              child: ConfettiWidget(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/confetti_emoji.png',
                              height: 100, width: 100),
                        ],
                      ),
                      Text(
                        "You're all set!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            child: Text(
                              "Join our official Discord Server for the latest updates!",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/discord.png',
                        height: 75,
                        width: 75,
                      )
                    ]),
                confettiController: _controller!,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.20,
                numberOfParticles: 20,
                blastDirection: -3.14 / 2,
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              shootConfetti();
            },
            child: Text('Shoot Confetti'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
