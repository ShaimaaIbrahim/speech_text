
import 'dart:collection';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
   late stt.SpeechToText _speechToText;
   bool isListing = false;
   String _text = 'Tap here to listnen';

   double confidence = 1.0;

final Map<String, HighlightedWord> _highLisghts = {

  "flutter" : HighlightedWord(
    textStyle: TextStyle(
      color: Colors.green
    )
  )
};
   @override
  void initState() {
     _speechToText = stt.SpeechToText();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence is ${(confidence* 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: isListing,
        glowColor: Colors.blue,
        endRadius: 90.0,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        child: FloatingActionButton(
          onPressed: _onPress,
          child: Icon(isListing ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextHighlight(
              text: _text,
              words: _highLisghts,
              textStyle: TextStyle(
                fontSize: 20,
                color: Colors.black87
              ),
            ),
          ),
        )
      ),
    );
  }
   _onPress() async{
      if(! isListing) {
       bool avaiable = await _speechToText.initialize(
        onStatus: (val) => print('onStaus : $val'),
        onError: (val) => print('onError $val')
       );
       if(avaiable){
          setState(() {
            isListing = true;
          });
          _speechToText.listen(
            onResult: (val) => setState(() {
              _text = val.recognizedWords;
              if(val.hasConfidenceRating && val.confidence > 0){
                  confidence = val.confidence;
              }
            })
          );
       }
      }
      else{
        setState(() {
          isListing= false;
        });
        _speechToText.stop();
      }
   }
}
