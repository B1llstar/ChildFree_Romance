import 'package:childfree_romance/TinderCard/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: ElevatedButton(
              child: Text('Restart'),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
              },
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.8, // 80% of screen height
                child: Stack(
                  children: users
                      .map((user) => TinderCard(
                            profile: {'profilePicture': user['profilePicture']},
                            isFront: users.last == user,
                          ))
                      .toList(),
                ),
              ),
              buildButtons(),
            ],
          );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;
    return Container(
      height: MediaQuery.of(context).size.height * 0.1, // 20% of screen height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                shape: MaterialStateProperty.all(CircleBorder())),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.dislike();
            },
            child: Icon(Icons.clear, color: Colors.red, size: 46),
          ),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.superLike();
            },
            child: Icon(Icons.star, color: Colors.blue, size: 46),
          ),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.like();
            },
            child: Icon(Icons.favorite, color: Colors.green, size: 46),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCards(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
