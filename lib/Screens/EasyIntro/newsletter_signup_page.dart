import 'package:flutter/material.dart';

class NewsletterPage extends StatelessWidget {
  const NewsletterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: 500,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text Field for getting dreamPartnerDescription
                      Text(
                          'Subscribe to our newsletter for updates & early access?',
                          style: TextStyle(fontSize: 24)),
                      Image.asset('assets/newspaper.png',
                          height: 200, width: 200),
                      // Two buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () {}, child: Text('Yes')),
                          ElevatedButton(
                              onPressed: () {}, child: Text('Maybe Later')),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
