import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * .75,
                  height: MediaQuery.of(context).size.height * .50,
                  color: Colors.blue,
                  child: EmailSignupCard()),
            ],
          ),
        ],
      ),
    );
  }
}

class EmailSignupCard extends StatefulWidget {
  const EmailSignupCard({super.key});

  @override
  State<EmailSignupCard> createState() => _EmailSignupCardState();
}

class _EmailSignupCardState extends State<EmailSignupCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Column(children: [
          TextFormField(),
          TextFormField(),
        ]));
  }
}
