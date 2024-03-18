import 'package:childfree_romance/Screens/Settings/Sections/essentials_section.dart';
import 'package:childfree_romance/Screens/Settings/Sections/misc_section.dart';
import 'package:childfree_romance/Screens/Settings/Sections/personal_beliefs.dart';
import 'package:childfree_romance/Screens/Settings/Sections/photo_manager_section.dart';
import 'package:childfree_romance/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';
import './Sections/match_preferences_section.dart' as matching;
import 'Sections/interests_settings_section.dart';
import 'Sections/lifestyle_section.dart';

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
    body:
    return Container(
      child: SettingsList(
        lightTheme: SettingsThemeData(
          titleTextColor: Colors.white,
          settingsListBackground: Colors.transparent,
        ),
        brightness: Brightness.dark,
        sections: [
          CustomSettingsSection(child: PhotoManagerSection()),
          CustomSettingsSection(child: EssentialsSettingsSection()),
          CustomSettingsSection(
              child: matching.MatchPreferencesSettingsSection()),
          CustomSettingsSection(child: LifestyleSettingsSection()),
          CustomSettingsSection(child: PersonalBeliefsSettingsSection()),
          CustomSettingsSection(child: MiscSettingsSection()),
          CustomSettingsSection(child: InterestsSettingsSection())
        ],
      ),
    );
  }

  SettingsTile buildSettingsTile(BuildContext context, String title,
      String leadingAsset, String property) {
    return SettingsTile(
      backgroundColor: Colors.white,
      title: Text(title),
      leading: Icon(Icons.add),
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
