import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';

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
  final gifController = GifController();
  String _status = 'N/A', _steps = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    gifController.pause();
    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
    gifController.play();
  }

  void _resetStepCount() {
    setState(() {
      _steps = 0.toString();
    });
    gifController.pause();
  }
  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'something went wrong';
    });
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
              defaultSpacing,
              Image.asset('images/bulbasaur_walking.png', fit: BoxFit.scaleDown),
              // GifView.network(
              //   'https://media.tenor.com/IiwcKW9Efl4AAAAi/bulbasaur-cute.gif',
              //   // controller: gifController,
              //   height: 200,
              // ),
              defaultSpacing,
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30),
              ),
              defaultSpacing,
              Text(
                _steps,
                style: const TextStyle(fontSize: 60),
              ),
              defaultSpacing,
              // const Text(
              //   'Pedestrian Status',
              //   style: TextStyle(fontSize: 30),
              // ),
              // Icon(
              //   _status == 'walking'
              //       ? Icons.directions_walk
              //       : _status == 'stopped'
              //           ? Icons.accessibility_new
              //           : Icons.error,
              //   size: 100,
              // ),
              // Center(
              //   child: Text(
              //     _status,
              //     style: _status == 'walking' || _status == 'stopped'
              //         ? const TextStyle(fontSize: 30)
              //         : const TextStyle(fontSize: 20, color: Colors.red),
              //   ),
              // )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _resetStepCount, 
          tooltip: 'Reset', 
          child: const Icon(Icons.refresh_rounded),
        ),
    );
  }
}
