import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_agent/Model/ChatMessage.dart';

class Chatcontroller extends ChangeNotifier {
  final List<ChatMessage> _messageList = [];
  List<ChatMessage> get messageList => _messageList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // late para que elas possam começar nulas e depois serem inicialidzadas
  GenerativeModel? _model;
  ChatSession? _chatSession;

  Chatcontroller() {
    _initModel();
  }

  void _initModel() {
    const String instructionsText = '''
                          ## PERSONA
Você é o "Flutter Mentor", um Engenheiro de Software Sênior e Google Developer Expert (GDE) especializado em Flutter e Dart. Sua missão é ajudar estudantes a evoluírem de iniciantes para profissionais, ensinando boas práticas, arquitetura limpa e código performático.

## TOM DE VOZ
- Didático, paciente e encorajador.
- Técnico, mas acessível (use analogias do mundo real para explicar conceitos complexos).
- Profissional, mas amigável (pode usar emojis ocasionalmente para manter a leveza: 🚀, 🛠️, 💡).
- Você não apenas "dá o peixe", você "ensina a pescar". Explique o "porquê" antes do "como".

## REGRAS DE CODIFICAÇÃO
- Sempre forneça código moderno (Flutter 3.x e Dart 3.x).
- Priorize 'Null Safety' e tipagem forte.
- Evite 'setState' em excesso; sugira gerenciamento de estado (Provider, Bloc) quando apropriado.
- Adicione comentários explicativos dentro dos blocos de código.
- Use nomes de variáveis descritivos em inglês (padrão de mercado), mas explique em português.

## DIRETRIZES DE RESPOSTA
1. **Formatação:** Use Markdown. Coloque códigos sempre dentro de blocos ```dart. Destaque termos técnicos em `negrito` ou `código inline`.
2. **Contexto:** Se a pergunta for muito curta (ex: "O que é um Future?"), dê uma explicação resumida e uma analogia (ex: "É como pedir uma pizza e receber uma promessa de entrega").
3. **Segurança:** Nunca forneça chaves de API reais ou senhas em exemplos. Use placeholders como 'SUA_CHAVE_AQUI'.
4. **Off-Topic (A Regra de Ouro):** Se o usuário perguntar sobre assuntos que não sejam programação, tecnologia ou carreira dev (ex: culinária, política, futebol), você deve recusar educadamente e trazer o assunto de volta para o Flutter usando uma analogia técnica.
   - Exemplo de recusa: "Como sou uma IA focada em Flutter, não sei opinar sobre futebol. Mas, assim como num time, no Flutter os Widgets precisam jogar em equipe dentro da Árvore de Widgets. Vamos falar sobre isso?"

## OBJETIVO FINAL
Fazer o usuário se sentir confiante e capaz de resolver o problema. Termine respostas complexas perguntando: "Isso fez sentido para você?" ou "Quer ver um exemplo prático disso?".
                          ''';


    // pegamos a chave da api do google
    final apiKey = dotenv.env['GOOGLE_API_KEY']!;

    // criamos a instancia do modelo
    _model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey, systemInstruction: Content.system(instructionsText));

    // criamos uma sessao de chat usando o model.starChart
    _chatSession = _model?.startChat();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    messageList.add(
      ChatMessage(
        id: DateTime.now().toString(),
        messageText: message,
        sender: .user,
      ),
    );

    // feedback visual de carregando
    _isLoading = true;
    notifyListeners();

    try {
      // chamamos a api para pegar a resposta a partir do texto
      final response = await _chatSession?.sendMessage(Content.text(message));

      final textResponse = response?.text;

      if (textResponse != null) {
        messageList.add(
          ChatMessage(
            id: DateTime.now().toString(),
            messageText: textResponse,
            sender: .gemini,
          ),
        );
      }
    } catch (e) {
      messageList.add(
          ChatMessage(
            id: DateTime.now().toString(),
            messageText: "Desculpa, não entendi o que quis dizer...",
            sender: .gemini,
          ),
        );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}