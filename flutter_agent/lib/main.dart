import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './Model/ChatMessage.dart';
import './Controller/ChatController.dart';
import './View/ChatPage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(ChangeNotifierProvider(
    create: (context) => Chatcontroller(),
    child: const App(),
    ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Mentor",
      debugShowCheckedModeBanner: false,
      home: const Chatpage(),
    );
  }
}