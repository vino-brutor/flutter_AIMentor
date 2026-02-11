import '../Model/ChatMessage.dart';
import '../Controller/ChatController.dart';
import 'ChatBubble.dart';
import '../Assets/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
  final chatcontroller = context.watch<Chatcontroller>();

    return Scaffold(
      backgroundColor: AppColors.carbonBlack,
      appBar: AppBar(
        title: Text("Mentor Flutter AI", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.dryBeige)),
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppColors.carbonBlack,
      ),
      body: Column(
        children: [
          Expanded(
            child: chatcontroller.messageList.isEmpty ? 
              _buildEptyState(context) :
              ListView.builder(
                controller: _scrollController, // usamos o controller de scrol aqui
                itemCount: chatcontroller.messageList.length,
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final message = chatcontroller.messageList[index];
                  return ChatBubble(message: message);
                },
              )
            ),

            if (chatcontroller.isLoading)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent, 
              color: AppColors.babyBlue,
              ),
            
            _buildInput(context)
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.dryBeige,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(0, -2), // Sombra pra cima
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        spacing: 8.0,
        children: [
          Expanded(
            // expandedn pra só ocupar o espaço disponível na tela pq text field é guloso
            child: TextField(
              onSubmitted: (_) {},
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem',
                hintStyle: TextStyle(color: AppColors.babyBlue),
                filled: true,
                fillColor: Colors.grey[700],
                contentPadding: EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),

          Consumer<Chatcontroller>(builder: (context, chatcontroller, child) {
            return FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.babyBlue,
              elevation: 0,
              mini: true,
              child: chatcontroller.isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send, color: Colors.white, size: 20),
              );
          })
        ],
      ),
    );
  }

  Widget _buildEptyState(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8,
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.school_outlined, size: 60, color: AppColors.skyBlue),

          Text(
            "Olá! Sou seu Mentor.",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),

          Text(
            "Vamos conversar sobre tudo de FLutter!",
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    final text = _textController.text;
    if(text.trim().isEmpty) return;

    context.read<Chatcontroller>().sendMessage(text);

    _textController.clear();

    // future.delayed faz a funcao tocar depois de um tempinho
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
