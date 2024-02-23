import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';

class SwipeInterface extends StatefulWidget {
  const SwipeInterface({super.key});

  @override
  State<SwipeInterface> createState() => _SwipeInterfaceState();
}

class _SwipeInterfaceState extends State<SwipeInterface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Swipe Interface'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * .75,
            child: AppinioSwiper(
              cardCount: 10,
              cardBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(index.toString()),
                  color: Colors.blue,
                );
              },
            ),
          ),
        ));
  }
}
