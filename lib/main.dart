import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:pokestrides/speech_bubbles.dart';

Map<int, String> milestones = {
  34560 : "1/100 of the distance to mountain view, ca!",
  345600 : "1/10 of the distance to mountain view, ca!",
  864000: "a quarter of the distance to mtv WOOHOOO!",
  1728000 : "a half the distance to mountain view!",
  3456000 : "distance to mountain view!"
};

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
  bool _showBulbasaur = true;
  int _numBubbleText = 0;

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
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    event.status == "walking" ? bulbasaurController.play() : bulbasaurController.stop();
  }

  void onPedestrianStatusError(error) {
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
              },
            ),
          ],
        );
      },
    );
  }

  void tapBulbasaurAction(SpeechBubbles speech, TapUpDetails tapDetails) {
    _setShowBulbasaur(false);
    _incrementNumBubbles();
    OverlayEntry speechBubble = speech.getSpeechBubble(context, tapDetails.globalPosition, speech.getRinQuote());
    Overlay.of(context).insert(speechBubble);

    // Remove speech bubble after delay
    Future.delayed(const Duration(seconds: 3), () {
      speechBubble.remove();
      _decrementNumBubbles();
      if (_numBubbleText == 0) {
        _setShowBulbasaur(true);
      }
    });
  }

  void _setShowBulbasaur(bool show) {
    setState(() {
      _showBulbasaur = show;
    });
  }

  void _decrementNumBubbles() {
    setState(() {
      if (_numBubbleText > 0) {
        _numBubbleText -= 1;
      }
    });
  }
  void _incrementNumBubbles() {
    setState(() {
      _numBubbleText += 1;
    });
  }

  @override  
  Widget build(BuildContext context) {
    SpeechBubbles speech = SpeechBubbles();
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
              GestureDetector(
                onTapUp: (TapUpDetails tapDetails) {
                  tapBulbasaurAction(speech, tapDetails);
                },
                child: _showBulbasaur
                  ? bulbasaurGif
                  : Image.asset('images/rin_tohsaka.png', fit: BoxFit.scaleDown, width: 200, height: 200),
              ),
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
