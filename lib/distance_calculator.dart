import 'dart:math';

class DistanceCalculator {
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var distanceInKm = 12742 * asin(sqrt(a));
    // Convert kilometers to miles (1 kilometer = 0.621371 miles)
    return distanceInKm * 0.621371;
  }

  String? getLocationString(Map<String, dynamic> data) {
    String locationString = '';
    if (data.containsKey('locale') && data['locale'] is Map<String, dynamic>) {
      if (data['locale'].containsKey('state')) {
        // We're in the United States
        locationString =
            '${data['locale']['city']}, ${data['locale']['state']}';
      } else {
        locationString =
            '${data['locale']['city']}, ${data['locale']['country']}';
      }
      if (data.containsKey('distance')) {
        locationString = '$locationString (${data['distance']} mi.)';
      }
      if (locationString.contains('N\/A, ')) {
        locationString = locationString.replaceAll('N\/A, ', '');
      }
      return locationString;
    }
  }
}
