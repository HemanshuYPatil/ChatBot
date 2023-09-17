import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:chatbot/model/question_answer.dart';
import 'package:chatbot/theme.dart';
import 'package:chatbot/view/components/chatgpt_answer_widget.dart';
import 'package:chatbot/view/components/loading_widget.dart';
import 'package:chatbot/view/components/text_input_widget.dart';
import 'package:chatbot/view/components/user_question_widget.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? answer;

  final loadingNotifier = ValueNotifier<bool>(false);
  final List<QuestionAnswer> questionAnswers = [];

  late ScrollController scrollController;
  late TextEditingController inputQuestionController;
  StreamSubscription<CompletionResponse>? streamSubscription;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    inputQuestionController = TextEditingController();
  }

  @override
  void dispose() {
    inputQuestionController.dispose();
    loadingNotifier.dispose();
    scrollController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  void response(query) async{
    AuthGoogle authGoogle = await AuthGoogle{
      fileJson:
    }
    Dialogflow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg500Color,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.white12,
        centerTitle: true,
        title: Text(
          "Chatbot",
          style: kWhiteText.copyWith(fontSize: 20, fontWeight: kSemiBold),
        ),
        backgroundColor: kBg300Color,
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildChatList(),
            TextInputWidget(
              textController: inputQuestionController,
              onSubmitted: () => _sendMessage(),
            )
          ],
        ),
      ),
    );
  }

  Expanded buildChatList() {
    return Expanded(
      child: ListView.separated(
        controller: scrollController,
        separatorBuilder: (context, index) => const SizedBox(
          height: 12,
        ),
        physics: const BouncingScrollPhysics(),
        padding:
        const EdgeInsets.only(bottom: 20, left: 16, right: 16, top: 16),
        itemCount: questionAnswers.length,
        itemBuilder: (BuildContext context, int index) {
          final question = questionAnswers[index].question;
          final answer = questionAnswers[index].answer;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              UserQuestionWidget(question: question),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: loadingNotifier,
                builder: (_, bool isLoading, __) {
                  if (answer.isEmpty && isLoading) {
                    _scrollToBottom();
                    return const LoadingWidget();
                  } else {
                    return ChatGptAnswerWidget(
                      answer: answer.toString().trim(),
                    );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  void _sendMessage() async {
    final question = inputQuestionController.text;
    inputQuestionController.clear();
    loadingNotifier.value = true;

    setState(() => questionAnswers
        .add(QuestionAnswer(question: question, answer: StringBuffer())));

    // You can handle user input or send it to a chatbot service here
  }

// You can implement the response handling logic here

}

