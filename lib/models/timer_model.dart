class TimerModel {
  String? iD;
  Duration? duration;
  bool? startStop;

  TimerModel(
      {this.iD,
      this.duration,
      this.startStop});

  TimerModel copyWith({
    String? iD,
    Duration? duration,
    bool? startStop,
  }) {
    return TimerModel(
      iD: iD ?? this.iD,
      duration: duration ?? this.duration,
      startStop: startStop ?? this.startStop,
    );
  }
}
