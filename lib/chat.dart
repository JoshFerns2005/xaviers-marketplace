import 'package:flutter/material.dart';
import 'package:xaviers_market/home_screen.dart';

void main() {
  runApp(chat());
}

class chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(sellerId: 'seller123'),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String sellerId;

  const ChatScreen({required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make the body extend behind the AppBar
      appBar: AppBar(
        title: const Text('Chat with Seller:'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        backgroundColor: Colors.transparent, // Make app bar transparent
        iconTheme: IconThemeData(color: Colors.white), // Set icon color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
      ),
      body: ChatScreenBody(sellerId: sellerId),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  final String sellerId;

  ChatScreenBody({required this.sellerId});

  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 63, 5, 73),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    '${message['sender']}: ${message['text']}',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    _sendMessage('user', _messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String sender, String text) {
    setState(() {
      _messages.add({'text': text, 'sender': sender});
    });
  }
}
