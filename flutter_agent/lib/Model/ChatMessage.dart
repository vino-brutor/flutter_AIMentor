import 'dart:ffi';

import 'package:flutter_agent/Enums/WhoSent.dart';

class ChatMessage {
    final String id;
    final String messageText;
    final Whosent sender;
    final bool isCode;

    ChatMessage({
      required this.id,
      required this.messageText,
      required this.sender,
      this.isCode = false,
    });
}