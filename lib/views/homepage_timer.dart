import 'package:flutter/material.dart';
import 'package:interview1/models/timer_model.dart';
import 'package:interview1/service/service.dart';
import 'package:interview1/widgets/timer.dart';
import 'package:interview1/widgets/helpers.dart';
import 'package:provider/provider.dart';
import 'package:themebykarthi/themebykarthi.dart';

import '../controller/timer_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ThemeData themeData;
  final TextEditingController minsController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();
  GlobalKey<FormState> timerForm = GlobalKey<FormState>();

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    final controller = context.watch<TimerController>();
    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.onSecondary,
        title: KustomText.headlineMedium(
          "Timer App",
          color: themeData.colorScheme.background,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            KustomContainer(
              padding: EdgeInsets.all(AppSize.s8!),
              enableBorderRadius: false,
              color: themeData.colorScheme.background,
              height: AppSize.screenHeight * 0.24,
              width: AppSize.screenWidth,
              child: Form(
                key: timerForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: KustomText.labelLarge(
                            "Minutes",
                            color: themeData.colorScheme.onTertiary,
                          ),
                        ),
                        horizontalSpace(AppSize.s8!),
                        Expanded(
                          flex: 4,
                          child: KustomTextFormFeild(
                            hintText: "Mins",
                            style: KustomTextStyle.titleSmall(
                              fontSize: 18,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 600,
                            ),
                            hintStylecolor: themeData.colorScheme.background,
                            fillColor: themeData.colorScheme.secondary,
                            controller: minsController,
                            autovalidateMode: AutovalidateMode.disabled,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Minutes Requried";
                              }
                              if (value.toInt() > 59) {
                                return "Minutes Must Less Than 60";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: KustomText.labelLarge(
                            "Seconds",
                            // fontSize: AppSize.s24,
                            color: themeData.colorScheme.onTertiary,
                          ),
                        ),
                        horizontalSpace(AppSize.s8!),
                        Expanded(
                          flex: 4,
                          child: KustomTextFormFeild(
                            hintText: "Secs",
                            style: KustomTextStyle.titleSmall(
                              fontSize: 18,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 600,
                            ),
                            autovalidateMode: AutovalidateMode.disabled,
                            hintStylecolor: themeData.colorScheme.background,
                            fillColor: themeData.colorScheme.secondary,
                            controller: secondsController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Seconds Requried";
                              }
                              if (value.toInt() > 60) {
                                return "Seconds Must Less Than or Equal to 60";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) =>
                                onSubmitForm(context, controller),
                          ),
                        ),
                      ],
                    ),
                    KustomButton(
                      margin: EdgeInsets.only(
                          left: AppSize.s30!, right: AppSize.s30!),
                      color: themeData.colorScheme.inversePrimary,
                      width: AppSize.screenWidth,
                      buttondecoration: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                        AppSize.s12!,
                      )),
                      text: KustomText.titleLarge(
                        "Add",
                        color: themeData.colorScheme.background,
                      ),
                      onPressed: () {
                        onSubmitForm(context, controller);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Consumer<TimerController>(
              builder: (cxt, timerController, __) {
                return timerController.listOfTimers.isNotEmpty
                    ? KustomContainer(
                        width: AppSize.screenWidth,
                        color: themeData.colorScheme.secondary,
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: timerController.listOfTimers.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            TimerModel model = timerController.listOfTimers[
                                timerController.listOfTimers.length -
                                    1 -
                                    index];
                            return TimerWidget(
                              key: Key("Timer${model.iD}"),
                              model: model,
                              controller: timerController,
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  void onSubmitForm(BuildContext context, TimerController controller) {
    if (controller.listOfTimers.length < 10) {
      FocusScope.of(context).unfocus();
      if (timerForm.currentState!.validate()) {
        controller.listOfTimers.add(
          TimerModel(
            iD: idGenerator(),
            startStop: true,
            duration: Duration(
              minutes: minsController.text.toInt(),
              seconds: secondsController.text.toInt(),
            ),
          ),
        );
        clearTextField();
      } else {
        isErrorSnackBar(context, message: "Minutes and Seconds are requried");
      }
    } else {
      clearTextField();
      isErrorSnackBar(context, message: "can’t add more than 10 items");
    }
  }

  void clearTextField() {
    setState(() {
      minsController.clear();
      secondsController.clear();
    });
  }
}
