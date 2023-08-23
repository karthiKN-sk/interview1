import 'package:flutter/material.dart';
import 'package:themebykarthi/themebykarthi.dart';

import '../models/timer_model.dart';

class TimerController extends ChangeNotifier {
  final _listOfTimers = <TimerModel>[];
  List<TimerModel> get listOfTimers => _listOfTimers;

  void removeItems(String itemsID) {
    _listOfTimers.removeWhere((element) => element.iD == itemsID);
    notifyListeners();
  }

  void updateItems(String itemsID, String remainingTime, bool startOrStop) {
    if (_listOfTimers.isNotEmpty) {
      int index = _listOfTimers.indexWhere((element) => element.iD == itemsID);
      var now = Duration(seconds: remainingTime.toInt());
      _listOfTimers[index].startStop = startOrStop;
      _listOfTimers[index].duration = now;
      notifyListeners();
    }
  }
}
