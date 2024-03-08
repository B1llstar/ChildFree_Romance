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
            settingsListBackground: Colors.deepPurpleAccent,
          ),
          sections: [
            SettingsSection(
              title: Text('General'),
              tiles: [
                buildSettingsTile(context, 'Name', 'assets/user.png', 'name'),
                buildSettingsTile(context, 'Age', 'assets/age.png', 'age'),
                buildSettingsTile(context, 'Sterilization Status',
                    'assets/stethoscope.png', 'sterilizationStatus'),
                buildJobSettingsTile(context),
              ],
            ),
            SettingsSection(
              title: Text('Match Preferences'),
              tiles: [
                buildSettingsTile(context, 'I want to match with...',
                    'assets/globe.png', 'matchWithGender'),
                buildSettingsTile(context, 'Open to Long-Distance?',
                    'assets/globe.png', 'canLongDistanceMatch'),
                buildSettingsTile(context, 'Relationship Type',
                    'assets/heart.png', 'relationshipType'),
                buildSettingsTile(context, 'Pets', 'assets/pet.png', 'pets'),
              ],
            ),
            SettingsSection(
              title: Text('Vices'),
              tiles: [
                buildSettingsTile(
                    context, 'Do you drink?', 'assets/mug.png', 'doesDrink'),
                buildSettingsTile(
                    context, 'Do you smoke?', 'assets/cigar.png', 'doesSmoke'),
                buildSettingsTile(
                    context, 'Do you partake?', 'assets/plant.png', 'does420'),
              ],
            ),
            SettingsSection(
              title: Text('Personal Beliefs'),
              tiles: [
                buildEducationSettingsTile(context),
                buildReligionSettingsTile(context),
                buildPoliticsSettingsTile(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsTile buildSettingsTile(BuildContext context, String title,
      String leadingAsset, String property) {
    return SettingsTile(
      backgroundColor: Colors.white,
      title: Text(title),

      /*
      leading: Container(
        height: 50,
        width: 40,
        child: Image.asset(leadingAsset),
      ),*/
      description: Text(
        Provider.of<UserDataProvider>(context).getProperty(property) ?? '',
      ),
      onPressed: (BuildContext context) {
        _showConfirmationDialog(
            context, title, property, ['Yes', 'No', 'Maybe']);
      },
    );
  }

  SettingsTile buildJobSettingsTile(BuildContext context) {
    return SettingsTile(
      title: Text('Job'),
      leading: Container(
        height: 10,
        width: 50,
        child: Image.asset('assets/job.png'),
      ),
      description: Text(
        Provider.of<UserDataProvider>(context).getProperty('job') ?? '',
      ),
      onPressed: (BuildContext context) {
        _showJobInputDialog(context);
      },
    );
  }

  void _showJobInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String job = '';
        return AlertDialog(
          title: Text('Enter Your Job'),
          content: TextField(
            onChanged: (value) {
              job = value;
            },
            decoration: InputDecoration(hintText: 'Enter your profession'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<UserDataProvider>(context, listen: false)
                    .setProperty('job', job);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  SettingsTile buildEducationSettingsTile(BuildContext context) {
    return SettingsTile(
      title: Text('Education'),
      leading: Container(
        height: 50,
        width: 50,
        child: Image.asset('assets/school.png'),
      ),
      description: Text(
        Provider.of<UserDataProvider>(context).getProperty('education') ?? '',
      ),
      onPressed: (BuildContext context) {
        _showConfirmationDialog(context, 'Education', 'education',
            ['High School', 'Bachelor\'s', 'Master\'s', 'Some Degree']);
      },
    );
  }

  SettingsTile buildReligionSettingsTile(BuildContext context) {
    return SettingsTile(
      title: Text('Religion'),
      leading: Container(
        height: 50,
        width: 50,
        child: Image.asset('assets/religion.png'),
      ),
      description: Text(
        Provider.of<UserDataProvider>(context).getProperty('religion') ?? '',
      ),
      onPressed: (BuildContext context) {
        _showConfirmationDialog(context, 'Religion', 'religion',
            ['Christian', 'Muslim', 'Atheist', 'Jewish', 'Agnostic']);
      },
    );
  }

  SettingsTile buildPoliticsSettingsTile(BuildContext context) {
    return SettingsTile(
      title: Text('Politics'),
      leading: Container(
        height: 50,
        width: 50,
        child: Image.asset('assets/politics.png'),
      ),
      description: Text(
        Provider.of<UserDataProvider>(context).getProperty('politics') ?? '',
      ),
      onPressed: (BuildContext context) {
        _showConfirmationDialog(context, 'Politics', 'politics',
            ['Liberal', 'Moderate', 'Conservative', 'Libertarian']);
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, String title,
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
                  Provider.of<UserDataProvider>(context, listen: false)
                      .setProperty(nameOfProperty, option);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedOption != null) {
      print('Selected option: $selectedOption');
      // Perform actions based on the selected option here
    }
  }
}
