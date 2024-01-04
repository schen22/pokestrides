import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';  
  

class SpeechBubbles {
  List<String> rinQuotes = [
    "I'm feeding you the last of my mana.",
    "If you've got no way to fight, you're just getting in the way!",
    "If you don't like pain, stand still. I'll finish you off nice and quickly!",
    "You'll get no help from me. Right here and now, show me what you've got!",
    "A first-rate mage like myself could never lose to a third-rate hack like you!",
    "Conquering the world seems like a pain in the butt",
    "I'm fighting to win. That's all.",
    "I'm Tohsaka Rin.",
    "You can't get a feel for how a city is laid out unless you go places in person.",
    "I'm amazed.",
    "This is good.",
    "What are you smirking at?",
    "The battle I've been waiting for ten years is about to begin."
  ];

  String getRinQuote() {
    return rinQuotes[Random().nextInt(rinQuotes.length)];
  }

  OverlayEntry getSpeechBubble(BuildContext context, Offset tapPosition, String textContent) {
    return OverlayEntry(
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
  } 
}
