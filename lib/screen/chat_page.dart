import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:chatbot/model/message.dart';
import 'package:chatbot/service/database.dart';
import 'package:chatbot/service/key.dart';
import 'package:chatbot/widgets/setting.dart';
import 'package:chatbot/widgets/message_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final ChatGoogleGenerativeAI chatModel = ChatGoogleGenerativeAI(
    apiKey: apiKey,
    defaultOptions: ChatGoogleGenerativeAIOptions(
      model: 'gemini-2.0-flash',
      temperature: 0,
    ),
  );
  final ChatService _chatService = ChatService();
  List<Message> _messages = [];
  bool _isLoading = false;
  Map<int, bool> isSpeaking = {};
  final String userId = "user_123";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMessages();
  }

  // hàm để bot đọc tin nhắn
  Future<void> _toggleSpeech(int index) async {
    if (isSpeaking[index] == true) {
      await flutterTts.stop();
      setState(() {
        isSpeaking[index] = false;
      });
    } else {
      await flutterTts.setLanguage("vi-VN");
      await flutterTts.setPitch(1.2);
      await flutterTts.setSpeechRate(0.9);

      setState(() {
        isSpeaking[index] = true;
      });

      if (_messages.isNotEmpty) {
        await flutterTts.speak(_messages[index].text);
      }

      flutterTts.setCompletionHandler(() {
        setState(() {
          isSpeaking[index] = false;
        });
      });
    }
  }

  // Lưu tin nhắn lên Firestore
  Future<void> saveMessages() async {
    await _chatService.saveMessageToFirestore(
        Message(text: _controller.text, isUser: true), userId
    );
  }

  // Đọc tin nhắn từ Firestore
  Future<void> loadMessages() async {
    _messages = await _chatService.loadMessagesFromFirestore(userId);
    setState(() {});
  }

  // xóa tin nhắn
  Future<void> _deleteConversation() async {
    await _chatService.deleteConversation(userId);
    setState(() {
      _messages.clear(); // Xóa tin nhắn trên giao diện sau khi xóa Firestore
    });
  }

  void geminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        setState(() {
          _messages.add(Message(text: _controller.text, isUser: true));
          _isLoading = true;
        });
        await _chatService.saveMessageToFirestore(
            Message(text: _controller.text, isUser: true), userId);
      } else {
        return null;
      }

      final List<ChatMessage> history = _messages.map((msg) {
        return msg.isUser
            ? ChatMessage.humanText(msg.text)
            : ChatMessage.ai(msg.text);
      }).toList();

      final response = await chatModel.invoke(PromptValue.chat(history));

      setState(() {
        _messages.add(Message(text: response.output.content, isUser: false));
        _isLoading = false;
      });

      await _chatService.saveMessageToFirestore(
          Message(text: response.output.content, isUser: false), userId);
      _controller.clear();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/gpt-robot.png'),
                SizedBox(width: 10),
                Text('Chatbot', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            // button setting
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SettingsDialog(onDeleteConversation: () async {
                        await _deleteConversation();
                        setState(() {
                          _messages.clear();
                        });
                        Navigator.pop(context);
                      });
                    });
              },
              icon: Icon(Icons.settings_rounded,
                  color: Theme.of(context).colorScheme.primary
              ),
            ),
          ],
        ),
      ),
      body: (_messages.isEmpty)
          ? Column(
              children: [
                Expanded(
                    child: Image.asset(
                  'assets/chatbot_hi.webp',
                  width: 350,
                )),
                // người dùng nhập tin nhắn
                MessageInput(
                  controller: _controller,
                  onSend: geminiModel,
                  isLoading: _isLoading,
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Align(
                          alignment: (message.isUser)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: message.isUser
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    borderRadius: message.isUser
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          )
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: message.isUser
                                        ? Theme.of(context).textTheme.bodyMedium
                                        : Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              if (!message.isUser)
                                IconButton(
                                  onPressed: () => _toggleSpeech(index),
                                  icon: Icon(isSpeaking[index] == true
                                      ? Icons.stop_circle_rounded
                                      : Icons.volume_up_outlined
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // người dùng nhập tin nhắn
                MessageInput(
                  controller: _controller,
                  onSend: geminiModel,
                  isLoading: _isLoading,
                ),
              ],
            ),
    );
  }
}
