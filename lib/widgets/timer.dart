// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interview1/controller/timer_controller.dart';
import 'package:interview1/models/timer_model.dart';
import 'package:themebykarthi/themebykarthi.dart';

class TimerWidget extends StatefulWidget {
  final TimerModel model;
  final TimerController controller;
  const TimerWidget({
    Key? key,
    required this.controller,
    required this.model,
  }) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String remainingTime = "";
  Timer? _timer;
  late bool startStop = widget.model.startStop!;
  StreamController<String> timerStream = StreamController<String>.broadcast();
  late ThemeData themeData;

  @override
  void initState() {
    if (startStop) {
      timer();
    } else {
      if (_timer != null && _timer!.isActive) _timer!.cancel();
    }
    prepareData();
    super.initState();
  }

  timer() {
    const oneSec = Duration(seconds: 1);
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    _timer = Timer.periodic(oneSec, (Timer timer) {
      try {
        int second = int.tryParse(remainingTime) ?? 0;
        second = second - 1;
        if (second < -1) return;
        remainingTime = second.toString();
        if (second == -1) {
          timer.cancel();

          debugPrint('timer cancelled');
        }
        if (second > 0) {
          timerStream.add(remainingTime);
        }
        if (second == 0) {
          widget.controller.removeItems(widget.model.iD!);
          timer.cancel();
        }
      } catch (e) {
        debugPrint("$e");
      }
    });
  }

  @override
  void dispose() {
    try {
      if (_timer != null && _timer!.isActive) _timer!.cancel();
    } catch (e) {
      debugPrint("$e");
    }
    super.dispose();
  }

  prepareData() {
    Duration myDuration = widget.model.duration!;
    remainingTime = myDuration.inSeconds.toString(); // convert to second
//    remainingTime = '10'; // change this value to test for min function
  }

  startOrStop() {
    if (startStop) {
      start();
    } else {
      stop();
    }
  }

  start() {
    startStop = false;
    setState(() {});
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    updateMethod();
  }

  stop() {
    startStop = true;
    setState(() {});
    updateMethod();

    timer();
  }

  Widget dayHourMinuteSecondFunction(BuildContext context, Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return KustomContainer(
      color: themeData.colorScheme.onSecondaryContainer,
      margin: EdgeInsets.only(top: AppSize.s5!, bottom: AppSize.s5!),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: _buildMS(
                twoDigitMinutes, twoDigitSeconds, AppSize.s14!, AppSize.s35!),
          ),
          Row(
            children: [
              KustomButton(
                color: startStop
                    ? themeData.colorScheme.error
                    : themeData.colorScheme.primary,
                buttondecoration: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                  AppSize.s12!,
                )),
                text: KustomText.bodyMedium(
                  startStop ? "Stop" : "Resume",
                  color: themeData.colorScheme.background,
                ),
                onPressed: startOrStop,
              ),
              horizontalSpace(AppSize.s5!),
              KustomButton(
                color: themeData.colorScheme.errorContainer,
                buttondecoration: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                  AppSize.s12!,
                )),
                text: KustomText.bodyMedium(
                  "Delete",
                  color: themeData.colorScheme.background,
                ),
                onPressed: () {
                  widget.controller.removeItems(widget.model.iD!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildMS(
    String twoDigitMinutes,
    String twoDigitSeconds,
    double fontSize,
    double size,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        twoDigitMinutes != "00"
            ? Row(
                children: [
                  KustomText.labelLarge(
                    "Mins",
                    color: !startStop
                        ? themeData.colorScheme.primary
                        : themeData.colorScheme.inversePrimary,
                  ),
                  horizontalSpace(AppSize.s2),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s10!),
                      color: themeData.colorScheme.surface,
                    ),
                    height: size,
                    width: size,
                    child: Center(
                      child: KustomText.displayMedium(
                        twoDigitMinutes,
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.displayLarge!,
                          fontSize: AppSize.s14,
                          fontWeight: 800,
                          color: !startStop
                              ? themeData.colorScheme.primary
                              : themeData.colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        horizontalSpace(AppSize.s6!),
        Row(
          children: [
            KustomText.labelLarge("Secs",
                color: !startStop
                    ? themeData.colorScheme.primary
                    : colorChange(twoDigitMinutes, twoDigitSeconds)),
            horizontalSpace(AppSize.s2),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s10!),
                color: themeData.colorScheme.background,
              ),
              height: size,
              width: size,
              child: Center(
                child: KustomText.displayMedium(
                  twoDigitSeconds,
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.displayLarge!,
                    fontSize: fontSize,
                    fontWeight: 800,
                    color: !startStop
                        ? themeData.colorScheme.primary
                        : colorChange(twoDigitMinutes, twoDigitSeconds,
                            color: themeData.colorScheme.inversePrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color colorChange(String mins, String secs, {Color? color}) {
    if (mins == "00") {
      if (secs.toInt() < 30) {
        return themeData.colorScheme.error;
      }
      return color ?? themeData.colorScheme.inversePrimary;
    } else {
      return color ?? themeData.colorScheme.inversePrimary;
    }
  }

  Widget dateWidget() {
    return StreamBuilder<String>(
        key: Key("${widget.model.iD}"),
        stream: timerStream.stream,
        initialData: "0",
        builder: (context, snapshot) {
          Widget remainTimeDisplay = Container();
          try {
            var now = Duration(seconds: remainingTime.toInt());
            Future.delayed(Duration.zero, () async {
              updateMethod();
            });
            remainTimeDisplay = dayHourMinuteSecondFunction(context, now);
          } catch (e) {
            debugPrint("$e");
          }

          return remainTimeDisplay;
        });
  }

  void updateMethod() {
    widget.controller.updateItems(widget.model.iD!, remainingTime, startStop);
  }

  // void updateStartStop(bool startStop) {
  //   final model = widget.model;
  //   model.copyWith(
  //     startStop: startStop,
  //     duration: Duration(
  //       seconds: remainingTime.toInt(),
  //     ),
  //   );
  //   widget.controller.updateItems(widget.model.iD!, remainingTime, startStop);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return dateWidget();
  }
}
