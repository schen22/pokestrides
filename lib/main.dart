import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';

List<String> randomSayings = [
  "PAIN IS WEAKNESS LEAVING THE BODY",
  "がんばって！",
];

List<String> rinQuotes = [
  "Victor, I'm feeding you the last of my mana. So take that Holy Grail and blast it so hard there won't be a single trace left!",
  "If you've got no way to fight, you're just getting in the way! If you're killed without accomplishing anything, then you'll have died for nothing!",
  "If you don't like pain, stand still. I'll finish you off nice and quickly!",
  "Victor, you'll get no help from me. Right here and now, show me what you've got!",
  "A first-rate mage like myself could never lose to a third-rate hack like you!"
];

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

  void _getSpeechBubble(BuildContext context, Offset tapPosition, String textContent) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double padding = 16.0;

        // Calculate the width and height based on the text content
        TextSpan textSpan = TextSpan(text: textContent, style: const TextStyle(fontSize: 16.0));
        TextPainter textPainter = TextPainter(text: textSpan, maxLines: null, textDirection: TextDirection.ltr);
        textPainter.layout(maxWidth: screenWidth * 0.75 + padding); // Set a maximum width for line wrapping

        double bubbleWidth = textPainter.width + padding;
        double bubbleHeight = textPainter.height + padding;

        // Calculate the position above the tapped area
        double bubbleX = tapPosition.dx - bubbleWidth / 2;
        double bubbleY = tapPosition.dy - bubbleHeight - 20.0;

        // Ensure the bubble stays within the screen boundaries
        if (bubbleX < 0) {
          bubbleX = 0;
        } else if (bubbleX + bubbleWidth > screenWidth) {
          bubbleX = screenWidth - bubbleWidth;
        }

        if (bubbleY < 0) {
          bubbleY = 0;
        } else if (bubbleY + bubbleHeight > screenHeight) {
          bubbleY = screenHeight - bubbleHeight;
        }

        return Positioned(
          left: bubbleX,
          top: bubbleY,
          child: ChatBubble(
            clipper: ChatBubbleClipper2(type: BubbleType.receiverBubble),
            backGroundColor: const Color(0xffE7E7ED),
            margin: const EdgeInsets.only(top: 20),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                textContent,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
        )
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    // Close the speech bubble after a delay (you can customize the delay)
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
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
              GestureDetector(
                onLongPressDown: (LongPressDownDetails tapDetails) {
                  _getSpeechBubble(context, tapDetails.globalPosition, randomSayings[Random().nextInt(randomSayings.length)]);
                },
                onVerticalDragUpdate: (DragUpdateDetails dragDetails) {
                  _getSpeechBubble(context, dragDetails.globalPosition, rinQuotes[Random().nextInt(rinQuotes.length)]);
                },
                child: bulbasaurGif, 
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
