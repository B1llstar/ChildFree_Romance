import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';
import '../../Utils/debug_utils.dart';

class CountryPickerPage extends StatefulWidget {
  final void Function(String) onCountryPicked;
  const CountryPickerPage({Key? key, required this.onCountryPicked})
      : super(key: key);

  @override
  _CountryPickerPageState createState() => _CountryPickerPageState();
}

class _CountryPickerPageState extends State<CountryPickerPage> {
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
                    Text('Choose your country!',
                        style: TextStyle(fontSize: 26)),
                    ElevatedButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            widget.onCountryPicked(country.name);
                            setState(() {
                              _userDataNotifier!.countryPicked = country.name;
                            });
                            DebugUtils.printDebug(
                                'Country picked: ' + country.name);
                          },
                        );
                      },
                      child: Text(_userDataNotifier!.countryPicked.isEmpty
                          ? 'Start'
                          : _userDataNotifier!.countryPicked),
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
