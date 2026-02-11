import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Model/ChatMessage.dart';
import './Controller/ChatController.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Chatcontroller(),
    child: const App(),
    ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}