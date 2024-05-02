// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:selby/core/configuration.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:selby/core/ui.dart';
import 'package:selby/models/chat_model.dart';
import 'package:selby/presentation/widgets/primary_textfield.dart';

class MessageScreen extends StatefulWidget {
  final String userId;
  final String receiver;
  const MessageScreen({
    Key? key,
    required this.userId,
    required this.receiver,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;

  List<MessageModel> messages = [];
  @override
  void initState() {
    connect();
    super.initState();
  }

  void connect() {
    socket = IO.io(Configuration.chatUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });
    socket.connect();
    socket.onConnect((data) {
      print("Socket Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage("destination", msg["message"]);
      });
    });

    socket.emit("signin", widget.userId);
    print(socket.connected);
  }

  void sendMessage(String message, String senderId, String receiverId) {
    setMessage("source", message);
    socket.emit("message",
        {"message": message, "senderId": senderId, "receiverId": receiverId});
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(type, message);
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // CircleAvatar(
            //   radius: 20,
            //   backgroundColor: Colors.white.withOpacity(0.3),
            // ),
            // const SizedBox(
            //   width: 15,
            // ),
            const Text(
              'Gaurav Huzuri',
              style: TextStyle(
                  fontSize: 18, fontFamily: ('Quicksand'), color: Colors.white),
            ),
            Spacer(),
            // const Icon(
            //   Icons.search_rounded,
            //   color: Colors.white70,
            //   size: 40,
            // )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 14.0, right: 14),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (messages[index].type == "source") {
                      return Text("${messages[index].message}");
                    } else {
                      return Text("${messages[index].message}");
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.withOpacity(0.2)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: AppColors.main,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Ionicons.camera_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: PrimaryTextField(
                          controller: messageController,
                          labelText: "Message",
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            sendMessage(messageController.text.trim(),
                                widget.userId, widget.receiver);
                            messageController.clear();
                          },
                          icon: Icon(
                            Ionicons.send,
                            color: AppColors.main,
                          ),
                        ),
                      ),
                    ],

                    ///thankyou alll of youuuuuu se you next tutorial
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
