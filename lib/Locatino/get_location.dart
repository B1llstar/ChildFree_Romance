import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geocoding Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _city = '';
  String state = '';
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geocoding Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'City: $_city',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'State: $state',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Latitude: $_latitude',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Longitude: $_longitude',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    loc.LocationData? locationData;
    loc.Location location = loc.Location();

    try {
      locationData = await location.getLocation();
      print(locationData.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);

      if (placemarks != null && placemarks.isNotEmpty) {
        setState(() {
          _city = placemarks[0].locality!;
          state = placemarks[0].administrativeArea!;
        });
      } else {
        setState(() {
          _city = 'Unknown';
          _latitude = 0.0;
          _longitude = 0.0;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
