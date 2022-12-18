import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class TextToSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  speak(String text) async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: textEditingController,
                ),
                ElevatedButton(
                  child: Text(
                    "Start Text To Speech",
                  ),
                  onPressed: () => speak(textEditingController.text),
                )
              ],
            )));
  }
}

class _HomePageState extends State<HomePage> {
  var _speechToText = stts.SpeechToText();
  bool islisteing = false;
  String text = "Please Press The Button For Speaking";
  void listen() async {
    if (!islisteing) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (erroeNotfication) => print("$erroeNotfication"),
      );
      if (available) {
        setState(() {
          islisteing = true;
        });
        _speechToText.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        islisteing = false;
      });
      _speechToText.stop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = stts.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech to Text",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  )),
            ),
          ),
          Container(
            child: TextToSpeech(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: islisteing,
        repeat: true,
        endRadius: 80,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 1000),
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child: Icon(islisteing ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
