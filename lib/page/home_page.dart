import 'package:flutter/material.dart';
import 'package:meeting_copilot_flutter/worker/gemini_worker.dart';
import 'package:meeting_copilot_flutter/worker/record_worker.dart';

import '../component/conversation_block.dart';
import '../entity/conversation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _inputController;

  late final ScrollController _conversationController;

  late final FocusNode _inputFocusNode;

  final List<Conversation> _conversations = [];

  int _curIndex = 0;

  late final GeminiWorker _geminiWorker;

  late final RecordWorker _recordWorker;

  List<String> _deviceLabels = [];

  String _selectedDevice = '';

  @override
  void initState() {
    _inputController = TextEditingController();
    _conversationController = ScrollController();
    _inputFocusNode = FocusNode();

    RecordWorker.listDevices().then((devices) {
      setState(() {
        _deviceLabels = devices.map((device) => device.label).toList();
        _selectedDevice = _deviceLabels.first;
      });
    });

    GeminiWorker.spawn([]).then((worker) => {
          _geminiWorker = worker,
          _geminiWorker.conversationStream.listen((conversation) {
            setState(() {
              _conversations[_curIndex] = conversation;
            });
            _curIndex++;
            _scrollDown();
          }),
        });
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    _geminiWorker.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<String>(
                  value: _selectedDevice,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDevice = newValue!;
                    });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  items: _deviceLabels
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value, // Ensure each value is unique
                      child: Text(value),
                    );
                  }).toList(), // Convert to set to remove duplicates
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: VerticalDivider(
              color: Colors.grey.withOpacity(0.3),
              thickness: 1,
            ),
          ),
          Expanded(
            flex: 75,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _conversationController,
                    itemCount: _conversations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ConversationBlock(
                        conversation: _conversations[index],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocusNode,
                    decoration: InputDecoration(
                      hintText: '请输入消息...',
                      border: const OutlineInputBorder(),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_upward_outlined,
                              size: 36,
                            ),
                            onPressed: () {
                              debugPrint('onPressed');
                            },
                          ),
                        ),
                      ),
                    ),
                    onSubmitted: (String question) {
                      if (question.isEmpty) {
                        return;
                      }
                      setState(() {
                        _conversations.add(Conversation(
                          question: question,
                          answer: '正在思考中...',
                        ));
                      });
                      _geminiWorker.chat(question);
                      _inputController.clear();
                      _inputFocusNode.requestFocus();
                      _scrollDown();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 滚动到最后一个元素
      _conversationController.animateTo(
        _conversationController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}
