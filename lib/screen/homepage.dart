import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
class _HomepageState extends State<Homepage> {
  // Please ensure you have imported the required packages for speechToText, flutterTts, and GoogleTranslator.
  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();
  final GoogleTranslator translator = GoogleTranslator();

  bool isListening = false;
  String recognizedText = '';
  String translatedText = '';
  String sourceLang = 'en';
  String targetLang = 'hi';

  final Map<String, String> languageMap = {
    'English': 'en',
    'Hindi': 'hi',
    'Marathi': 'mr',
    'Russian': 'ru',
    'Spanish': 'es',
  };

  Future<void> _startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => isListening = true);
      speech.listen(
        localeId: sourceLang,
        onResult: (result) async {
          recognizedText = result.recognizedWords;
          setState(() {});
          if (recognizedText.isNotEmpty) {
            await translateAndSpeak(recognizedText);
          }
        },
      );
    }
  }

  Future<void> translateAndSpeak(String text) async {
    final translation = await translator.translate(text, to: targetLang);
    translatedText = translation.text;
    await tts.setLanguage(targetLang);
    await tts.speak(translatedText);
    setState(() {});
  }

  @override
  void dispose() {
    speech.stop();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livetranslator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'From Language'),
              value: languageMap.entries.firstWhere((e) => e.value == sourceLang).key,
              items: languageMap.keys.map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (value) => setState(() => sourceLang = languageMap[value]!),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'To Language'),
              value: languageMap.entries.firstWhere((e) => e.value == targetLang).key,
              items: languageMap.keys.map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (value) => setState(() => targetLang = languageMap[value]!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startListening,
              child: Text(isListening ? "Listening..." : "Start Speaking"),
            ),
            const SizedBox(height: 20),
            Text("You said: $recognizedText"),
            const SizedBox(height: 10),
            Text("Translated: $translatedText"),
          ],
        ),
      ),
    );
  }
}