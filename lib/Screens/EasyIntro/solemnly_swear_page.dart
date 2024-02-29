import 'package:childfree_romance/Notifiers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SolemnlySwearPage extends StatefulWidget {
  final void Function(bool) onChecked;
  const SolemnlySwearPage({Key? key, required this.onChecked})
      : super(key: key);

  @override
  _SolemnlySwearPageState createState() => _SolemnlySwearPageState();
}

class _SolemnlySwearPageState extends State<SolemnlySwearPage> {
  UserDataProvider? _userDataNotifier;

  @override
  Widget build(BuildContext context) {
    _userDataNotifier ??= Provider.of<UserDataProvider>(context, listen: false);
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
                    CheckboxListTile(
                      title: Text(
                          'I solemnly swear that I do not have children, and am certain that I will never, EVER want them. Ever. Seriously, my mind is made up.'),
                      value: _userDataNotifier!.hasSolemnlySworn,
                      onChanged: (value) {
                        setState(() {
                          widget.onChecked(value!);
                          _userDataNotifier!.hasSolemnlySworn = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
