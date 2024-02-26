import 'package:flutter/material.dart';

class ChooseGenderIdentityCardScreen extends StatefulWidget {
  const ChooseGenderIdentityCardScreen({Key? key}) : super(key: key);

  @override
  State<ChooseGenderIdentityCardScreen> createState() =>
      _ChooseGenderIdentityCardScreenState();
}

class _ChooseGenderIdentityCardScreenState
    extends State<ChooseGenderIdentityCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Which do you closest identify with?',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 36)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenderCard(
                icon: Icons.male,
                iconColor: Colors.blue,
                onPressed: () {
                  // handle male icon pressed
                  print('Male icon pressed');
                },
              ),
              GenderCard(
                iconColor: Colors.pink,
                icon: Icons.female,
                onPressed: () {
                  // handle female icon pressed
                  print('Female icon pressed');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GenderCard extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  const GenderCard({
    required this.icon,
    required this.onPressed,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: iconColor,
            size: 64.0,
          ),
        ),
      ),
    );
  }
}
