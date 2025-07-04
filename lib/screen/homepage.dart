import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();
  final GoogleTranslator translator = GoogleTranslator();

  bool isListening = false;
  String recognizedText = '';
  String translatedText = '';
  String sourceLang = 'en';
  String targetLang = 'hi';

  late AnimationController _micAnimationController;

  final Map<String, String> languageMap = {
    'English': 'en',
    'Hindi': 'hi',
    'Marathi': 'mr',
    'Russian': 'ru',
    'Spanish': 'es',
  };

  @override
  void initState() {
    super.initState();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  Future<void> _startListening() async {
    if (isListening) {
      await speech.stop();
      setState(() => isListening = false);
      return;
    }

    bool available = await speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        recognizedText = '';
        translatedText = '';
      });

      speech.listen(
        localeId: sourceLang,
        onResult: (result) async {
          recognizedText = result.recognizedWords;
          setState(() {});
          if (recognizedText.isNotEmpty) {
            await translateAndSpeak(recognizedText);
            setState(() => isListening = false);
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

  void _clearTexts() {
    setState(() {
      recognizedText = '';
      translatedText = '';
    });
  }

  void _swapLanguages() {
    setState(() {
      String temp = sourceLang;
      sourceLang = targetLang;
      targetLang = temp;
    });
  }

  @override
  void dispose() {
    speech.stop();
    tts.stop();
    _micAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('🎙️ Live Translator'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Language Dropdowns + Swap
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'From Language',
                      border: OutlineInputBorder(),
                    ),
                    value: languageMap.entries
                        .firstWhere((e) => e.value == sourceLang)
                        .key,
                    items: languageMap.keys.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => sourceLang = languageMap[value]!),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 28),
                  onPressed: _swapLanguages,
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'To Language',
                      border: OutlineInputBorder(),
                    ),
                    value: languageMap.entries
                        .firstWhere((e) => e.value == targetLang)
                        .key,
                    items: languageMap.keys.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => targetLang = languageMap[value]!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Microphone Button
            GestureDetector(
              onTap: _startListening,
              child: ScaleTransition(
                scale: _micAnimationController,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: isListening
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isListening ? "Listening..." : "Tap mic to start speaking",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            // Clear Button
            ElevatedButton.icon(
              onPressed: _clearTexts,
              icon: const Icon(Icons.clear),
              label: const Text("Clear All"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Output Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Listening...:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(recognizedText, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 15),
                  Text(
                    "Translating...:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    translatedText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
