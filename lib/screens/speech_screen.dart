import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/model/chat_model.dart';
import 'package:voice_assistant/services/api_services.dart';

import '../constants/colors.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var text = "Hold the button and start talking";
  var isListening = false;
  final List<ChatMessage> messages = [];
  var scrollController = ScrollController();
  TextEditingController inp_controller = TextEditingController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: AvatarGlow(
      //   endRadius: 75.0,
      //   animate: isListening,
      //   duration: Duration(milliseconds: 2000),
      //   glowColor: bgColor,
      //   repeat: true,
      //   repeatPauseDuration: Duration(milliseconds: 100),
      //   showTwoGlows: true,
      //   child: GestureDetector(
      //     onTapDown: (details) async {
      //       if (!isListening) {
      //         var available = await speechToText.initialize();
      //         if (available) {
      //           setState(() {
      //             isListening = true;
      //             speechToText.listen(onResult: (result) {
      //               setState(() {
      //                 text = result.recognizedWords;
      //               });
      //             });
      //           });
      //         }
      //       }
      //       setState(() {
      //         isListening = true;
      //       });
      //     },
      //     onTapUp: (details) async {
      //       setState(() {
      //         isListening = false;
      //       });
      //       speechToText.stop();
      //       messages.add(ChatMessage(text: text, type: ChatMessageType.user));
      //       var msg = await Api_Service.sendMessage(text);
      //       setState(() {
      //         messages.add(ChatMessage(text: msg, type: ChatMessageType.bot));
      //       });
      //     },
      //     child: const CircleAvatar(
      //       backgroundColor: bgColor,
      //       radius: 23,
      //       child: Icon(
      //         Icons.mic,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: const Icon(
          Icons.sort_rounded,
          color: Colors.white,
        ),
        title: Text(
          "Voice Assistant",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              // alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              // margin: const EdgeInsets.only(bottom: 150),
              child: Column(
                children: [
                  // Text(
                  //   text,
                  //   style: const TextStyle(
                  //     fontSize: 24,
                  //     color: Colors.black54,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: chatBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            var chat = messages[index];
                            return chatBubble(
                                chattext: chat.text, type: chat.type);
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Text(
                  //   "Developed By Chinmay",
                  //   style: TextStyle(
                  //     color: Colors.black54,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 24),
                  child: TextField(
                    controller: inp_controller,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          setState(() {
                            text = inp_controller.text;
                          });
                          speechToText.stop();
                          messages.add(ChatMessage(
                              text: text, type: ChatMessageType.user));
                          inp_controller.clear();
                          var msg = await Api_Service.sendMessage(text);
                          setState(() {
                            messages.add(ChatMessage(
                                text: msg, type: ChatMessageType.bot));
                          });
                        },
                        child: Icon(
                          Icons.send,
                          color: bgColor,
                        ),
                      ),
                      suffixIconColor: bgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 24),
                  child: AvatarGlow(
                    endRadius: 25,
                    duration: Duration(milliseconds: 2000),
                    glowColor: bgColor,
                    repeat: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    showTwoGlows: true,
                    child: GestureDetector(
                      onTapDown: (details) async {
                        if (!isListening) {
                          var available = await speechToText.initialize();
                          if (available) {
                            setState(() {
                              isListening = true;
                              speechToText.listen(onResult: (result) {
                                setState(() {
                                  text = result.recognizedWords;
                                });
                              });
                            });
                          }
                        }
                        setState(() {
                          isListening = true;
                        });
                      },
                      onTapUp: (details) async {
                        setState(() {
                          isListening = false;
                        });
                        speechToText.stop();
                        messages.add(ChatMessage(
                            text: text, type: ChatMessageType.user));
                        var msg = await Api_Service.sendMessage(text);
                        setState(() {
                          messages.add(ChatMessage(
                              text: msg, type: ChatMessageType.bot));
                        });
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: bgColor,
                        child: Icon(
                          Icons.mic,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget chatBubble({required chattext, required ChatMessageType? type}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatMessageType.bot
              ? Image.asset('assets/gpt.png')
              : Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                  color: chatBgColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
