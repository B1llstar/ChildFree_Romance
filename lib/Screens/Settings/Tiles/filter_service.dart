import 'package:childfree_romance/Screens/Settings/Tiles/settings_service.dart';

class FilterService {
  List<UserRank> filterByDesiredGenderRomance(
      UserRank user, List<UserRank> otherUsers) {
    List<UserRank> filterByGender;
    if (user.userSettings.desiredGenderRomance == 'Male') {
      filterByGender = otherUsers
          .where((element) => element.userSettings.gender == 'Male')
          .toList();
    } else if (user.userSettings.desiredGenderRomance == 'Female') {
      filterByGender = otherUsers
          .where((element) => element.userSettings.gender == 'Female')
          .toList();
    } else {
      filterByGender = otherUsers
          .where((element) =>
              element.userSettings.desiredGenderRomance ==
              user.userSettings.gender)
          .toList();
    }

    // Remove users where desired gender romance does not match the gender of the current user
    filterByGender.removeWhere((element) =>
        element.userSettings.desiredGenderRomance != user.userSettings.gender);

    return filterByGender;
    // Now filterByGender contains the correctly filtered list based on user's desired gender romance
  }

  List<UserRank> filterByDesiredGenderFriendship(
      UserRank user, List<UserRank> otherUsers) {
    List<UserRank> filterByGender;

    if (user.userSettings.desiredGenderFriendship == 'Male') {
      filterByGender = otherUsers
          .where((element) => element.userSettings.gender == 'Male')
          .toList();
    } else if (user.userSettings.desiredGenderFriendship == 'Female') {
      filterByGender = otherUsers
          .where((element) => element.userSettings.gender == 'Female')
          .toList();
    } else {
      filterByGender = otherUsers
          .where((element) =>
              element.userSettings.desiredGenderFriendship ==
              user.userSettings.gender)
          .toList();
    }

    // Remove users where desired gender romance does not match the gender of the current user
    filterByGender.removeWhere((element) =>
        element.userSettings.desiredGenderFriendship !=
        user.userSettings.gender);
    return filterByGender;
    // Now filterByGender contains the correctly filtered list based on user's desired gender romance
  }

  List<UserRank> removeAllUsersOfAgeZero(List<UserRank> rankedUsers) {
    return rankedUsers
        .where((userRank) => userRank.userSettings.age != 0)
        .toList();
  }
}
