import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {
  runApp(const PokeStrides());
}

class PokeStrides extends StatelessWidget {
  const PokeStrides({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Derping around',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
        ),
      home: const StepCountPage(title: 'PokéStrides'),
    );
  }
}

class StepCountPage extends StatefulWidget {
  const StepCountPage({super.key, required this.title});
  final String title;

  @override
  State<StepCountPage> createState() => _PokeStridesState();
}

const defaultSpacing = Divider(
  height:10,
  thickness: 0,
  color: Colors.white,
);

class _PokeStridesState extends State<StepCountPage> {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  final bulbasaurController = GifController();
  late GifView bulbasaurGif;
  String _steps = '0';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final keyStepsToReset = 'steps_to_reset';

  @override
  void initState() {
    super.initState();
    bulbasaurGif = GifView.asset(
      'images/bulbasaur_walking_cropped.gif', 
      controller: bulbasaurController,
      height: 200,
    );
    initPlatformState();
    // _prefs.then((SharedPreferences prefs) {
    //   if (!prefs.containsKey(keyStepsToReset)) {
    //     prefs.setInt(keyStepsToReset, 0);
    //     print("keyStepsToReset initialized!");
    //   }
    // });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    print("listening to step count");
    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    print("onStepCount reached");
    setState(() {
      print("setting state");
      _steps = calculateTotalSteps(event).toString();
    });
  }

  int calculateTotalSteps(StepCount event) {
    // _prefs.then((SharedPreferences prefs) {
    //   if (!prefs.containsKey(keyStepsToReset)) {
    //     prefs.setInt(keyStepsToReset, 0);
    //     print("keyStepsToReset initialized in calculateTotalSteps");
    //   }
    //   int currentTotalResetSteps = prefs.getInt(keyStepsToReset) ?? 0;
    //   int totalSteps = event.steps + currentTotalResetSteps;
    //   if (totalSteps < 0) {
    //     // something went wrong; sync key to total steps
    //     prefs.setInt(keyStepsToReset, -1 * event.steps);
    //     return 0;
    //   }
    //   return totalSteps;
    // });

    return event.steps;
  }

  // void _resetStepCount() {
  //   setState(() {
  //     _prefs.then((SharedPreferences prefs) {
  //       prefs.setInt(keyStepsToReset, -1 * int.parse(_steps));
  //       _steps = 0.toString();
  //     });
  //   });
  // }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    event.status == "walking" ? bulbasaurController.play() : bulbasaurController.stop();
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    bulbasaurController.play(inverted:true);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'something went wrong';
    });
  }

  void _showUserAgreement(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("User Agreement"),
          content: const Text(
            'This User Agreement contains\n' 
            'important information about how\n'
            'to uphold friendship. By clicking\n'
            'accept you agree to run a half\n'
            'marathon. And no bug reports.'
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
                // _prefs.setBool(keyIsColdStart, false);
              },
            ),
          ],
        );
      },
    );
  }


  @override  
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ElevatedButton(
              //   onPressed: () {
              //     _showUserAgreement(context);
              //   },
              //   child: const Text('Show User Agreement'),
              // ),
              // defaultSpacing,
              bulbasaurGif,
              defaultSpacing,
              const Text(
                'Strides Taken',
                style: TextStyle(fontSize: 30),
              ),
              defaultSpacing,
              Text(
                _steps,
                style: const TextStyle(fontSize: 60),
              ),
              defaultSpacing,
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showUserAgreement(context);
          },
          tooltip: 'Show user agrement', 
          child: const Icon(Icons.directions_run_sharp),
        ),
    );
  }
}
