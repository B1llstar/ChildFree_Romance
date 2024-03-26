import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  List<String> _urlImages = [];
  List<String> get urlImages => _urlImages;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> get users => _users;
  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _angle = 0;

  double get angle => _angle;
  Size _screenSize = Size.zero;

  Size get screenSize => _screenSize;

  bool get isDragging => _isDragging;

  Offset get position => _position;

  CardProvider() {}
  void setScreenSize(Size size) {
    _screenSize = size;
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();
    final status = getStatus(force: true);

    if (status != null) {
      if (!kIsWeb) {
        print(status.toString().split('.').last.toUpperCase());
      } else {
        print(status.toString().split('.').last.toUpperCase());
      }
    }
    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        resetPosition();
    }
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(Duration(milliseconds: 200));
    _urlImages.removeLast();
    resetPosition();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;
    if (force) {
      final delta = 100;
      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      final delta = 20;
      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    }
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  void resetUsers(List<Map<String, dynamic>> users) {
    _users = users.reversed.toList();
    /*
    _users = [
      {
        'profilePicture':
            'https://cdn.britannica.com/47/188747-050-1D34E743/Bill-Gates-2011.jpg',
      },
      {
        'profilePicture':
            'https://nhpbs.org/wild/images/whitepelicanjohnfosterusfw.jpg'
      }
    ].reversed.toList();
*/
    notifyListeners();
  }
}
