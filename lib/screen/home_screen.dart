import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('websocket'),
      ),
      body: Column(
        children: [
          Form(
            child: TextFormField(
              // 컨트롤러 항목에 _controller 설정
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
          ),
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              return Center(
                child:
                    Text(snapshot.hasData ? '${snapshot.data}' : '데이터가 없습니다.'),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendMessage,
        child: const Icon(Icons.send),
      ),
    );
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }
}
