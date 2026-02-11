import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../Model/ChatMessage.dart';
import '../../Assets/AppColors.dart';

class ChatBubble extends StatefulWidget {

  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  _ChatBubble createState() => _ChatBubble();
}

class _ChatBubble extends State<ChatBubble> {

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.sender == .user;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        
        // da limite para o balão para que seja no máximo 75% da tela
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),

        // o decoration é o css do container, e aqui usamos o box decoration
        decoration: BoxDecoration(
          color: isUser ? AppColors.skyBlue : Colors.grey[500],

          borderRadius: BorderRadius.only(
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0, 2),
              blurRadius: 4,
            )
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
           if (!isUser) ...[
              const Icon(
                Icons.auto_awesome, 
                color: AppColors.skyBlue, 
                size: 20,
              ), 
            ],

            isUser ?
              Text(
                widget.message.messageText,
                style: const TextStyle(color: AppColors.carbonBlack, fontSize: 14)
                ) :
              MarkdownBody( // para usarmos o markdown, e podemos estilizar cada parte
                    data: widget.message.messageText,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: AppColors.carbonBlack, fontSize: 14),
                      code: const TextStyle(
                          backgroundColor: Colors.black12, 
                          fontFamily: 'monospace',
                          fontSize: 14),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}