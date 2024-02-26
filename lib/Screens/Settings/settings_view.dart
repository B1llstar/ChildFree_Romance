import 'package:childfree_romance/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MaterialApp(
        title: 'Settings Demo',
        theme: ThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          primarySwatch: Colors.blue,
        ),
        home: SettingsView(),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: SettingsList(
            lightTheme: SettingsThemeData(
                titleTextColor: Colors.white,
                settingsListBackground: Colors.deepPurpleAccent),
            sections: [
              SettingsSection(
                title: Text('General'),
                tiles: [
                  SettingsTile(
                    title: Text('Name'),
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/user.png'),
                    ),
                    description: Text(
                      Provider.of<UserDataProvider>(context)
                              .getProperty('name') ??
                          '',
                    ),
                    onPressed: (BuildContext context) {
                      _showConfirmationDialog(
                          context, 'Hi', 'name', ['Yes', 'No']);
                    },
                  ),
                  SettingsTile(
                    title: Text('Age'),
                    leading: Container(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/age.png')),
                    description: Text(
                      Provider.of<UserDataProvider>(context)
                              .getProperty('age') ??
                          '',
                    ),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: Text('Sterilization Status'),
                    leading: Container(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/stethoscope.png')),
                    description: Text(
                      Provider.of<UserDataProvider>(context)
                              .getProperty('sterilizationStatus') ??
                          '',
                    ),
                    onPressed: (BuildContext context) {
                      _showConfirmationDialog(
                          context,
                          'Hi',
                          'sterilizationStatus',
                          ['Sterilized', 'Not Sterilized', 'Will Sterilize']);
                    },
                  ),
                  SettingsTile.switchTile(
                    title: Text('Show Me'),
                    leading: Icon(Icons.fingerprint),
                    enabled: Provider.of<UserDataProvider>(context)
                            .getProperty('showMe') ??
                        false,
                    onToggle: (bool value) async {
                      String? selectedOption = await _showConfirmationDialog(
                        context,
                        'Confirmation',
                        'showMe',
                        ['Yes', 'No'],
                      );
                      if (selectedOption != null && selectedOption == 'Yes') {
                        Provider.of<UserDataProvider>(context, listen: false)
                            .setProperty('showMe', value);
                      }
                    },
                    initialValue: false,
                  ),
                ],
              ),
              SettingsSection(title: Text('Match Preferences'), tiles: [
                SettingsTile(
                    leading: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/globe.png')),
                    title: Text('I want to match with...'),
                    description: Text(Provider.of<UserDataProvider>(context)
                            .getProperty('matchWithGender') ??
                        ''),
                    onPressed: (context) {
                      _showConfirmationDialog(
                          context,
                          'I want to match with...',
                          'matchWithGender',
                          ['Males', 'Females', 'Everyone']);
                    }),
                SettingsTile(
                    leading: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/globe.png')),
                    title: Text('Open to Long-Distance?'),
                    description: Text(Provider.of<UserDataProvider>(context)
                            .getProperty('canLongDistanceMatch') ??
                        ''),
                    onPressed: (context) {
                      _showConfirmationDialog(
                          context,
                          'I am open to long-distance...',
                          'canLongDistanceMatch',
                          ['Yes', 'No']);
                    }),
              ]),
              SettingsSection(title: Text('Vices'), tiles: [
                SettingsTile(
                    leading: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/mug.png')),
                    title: Text('Do you drink?'),
                    description: Text(Provider.of<UserDataProvider>(context)
                            .getProperty('doesDrink') ??
                        ''),
                    onPressed: (context) {
                      _showConfirmationDialog(context, 'Do you drink?',
                          'doesDrink', ['Yes', 'No', 'Sometimes']);
                    }),
                SettingsTile(
                    leading: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/cigar.png')),
                    title: Text('Do you smoke?'),
                    description: Text(Provider.of<UserDataProvider>(context)
                            .getProperty('doesSmoke') ??
                        ''),
                    onPressed: (context) {
                      _showConfirmationDialog(context, 'Do you smoke?',
                          'doesSmoke', ['Yes', 'No', 'Sometimes']);
                    }),
                SettingsTile(
                    leading: Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/plant.png')),
                    title: Text('Do you partake?'),
                    description: Text(Provider.of<UserDataProvider>(context)
                            .getProperty('does420') ??
                        ''),
                    onPressed: (context) {
                      _showConfirmationDialog(context, 'Do you partake?',
                          'does420', ['Yes', 'No', 'Sometimes']);
                    }),
              ]),
            ]
            // Add other sections as needed
            ),
      ),
    );
  }
}

Future<String?> _showConfirmationDialog(BuildContext context, String title,
    String nameOfProperty, List<String> options) async {
  final selectedOption = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                Navigator.of(context).pop(option);
              },
            );
          }).toList(),
        ),
      );
    },
  );

  if (selectedOption != null) {
    UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    userDataProvider.setProperty(nameOfProperty, selectedOption);
    print('Selected option: $selectedOption');
    // Perform actions based on the selected option here
  }

  return selectedOption;
}
