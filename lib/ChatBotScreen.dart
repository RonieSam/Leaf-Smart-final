import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _getBotResponse(text);
  }

  void _getBotResponse(String userMessage) {
    String botResponse = _generateResponse(userMessage);
    ChatMessage botMessage = ChatMessage(
      text: botResponse,
      isUser: false,
    );
    setState(() {
      _messages.insert(0, botMessage);
    });
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _generateResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    if (userMessage.contains('hello') || userMessage.contains('hi')) {
      return "Hello! I'm LeafSmart, your agricultural assistant. How can I help you today?";
    } else if (userMessage.contains('crops') || userMessage.contains('plant')) {
      return "There are many crops you can plant depending on your climate and soil. Some popular options include wheat, rice, corn, and soybeans. What specific information are you looking for?";
    } else if (userMessage.contains('fertilizer') || userMessage.contains('nutrient')) {
      return "Fertilizers are essential for plant growth. The three main nutrients in fertilizers are nitrogen (N), phosphorus (P), and potassium (K). Each plays a different role in plant health and development.";
    } else if (userMessage.contains('pest') || userMessage.contains('insect')) {
      return "Pest management is crucial in agriculture. Some common pests include aphids, caterpillars, and beetles. Integrated Pest Management (IPM) is an eco-friendly approach to control pests.";
    } else if (userMessage.contains('water') || userMessage.contains('irrigation')) {
      return "Proper irrigation is key to crop success. Methods include drip irrigation, sprinkler systems, and flood irrigation. The best method depends on your crop type and local climate.";
    } else {
      return "I'm not sure about that. Could you ask me something about crops, fertilizers, pests, or irrigation?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("LeafSmart Assistant"),
    backgroundColor: Colors.green,
    ),
    body: Column(
    children: [
    Flexible(
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        padding: const EdgeInsets.all(8.0),
        itemCount: _messages.length,
        itemBuilder: (_, int index) => _messages[index],
      ),
    ),
      const Divider(height: 1.0),
      Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        child: _buildTextComposer(),
      ),
    ],
    ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
    children: [
    Flexible(
    child: TextField(
      controller: _textController,
      onSubmitted: _handleSubmitted,
      decoration: const InputDecoration.collapsed(
        hintText: "Ask me about agriculture...",
      ),
    ),
    ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => _handleSubmitted(_textController.text),
        ),
      ),
    ],
    ),
        ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(isUser ? 'You' : 'Bot'),
              backgroundColor: isUser ? Colors.blue : Colors.green,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isUser ? 'You' : 'LeafSmart',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}