/*This is the Individual Chat Screen*/
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:selby/core/configuration.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/models/msg_model.dart';
import 'package:selby/presentation/widgets/primary_textfield.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:selby/services/msg_services.dart';

class IndividualChatScreen extends StatefulWidget {
  final String userId;
  final String receiver;
  final String productId;
  const IndividualChatScreen({
    Key? key,
    required this.userId,
    required this.receiver,
    required this.productId,
  }) : super(key: key);

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;

  _sendMessage() async {
    var msgProv = Provider.of<MessageProvider>(context, listen: false);
    MessageService messageService = MessageService();
    await Provider.of<MessageProvider>(context, listen: false).sendMessage(
      clientId: widget.receiver,
      userModel: widget.userId,
      message: messageController.text.trim(),
      roomId: '',
      productId: widget.productId,
    );
    messageController.clear();
  }

  @override
  void initState() {
    var msgProv = Provider.of<MessageProvider>(context, listen: false);

    super.initState();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    socket = IO.io(
        Platform.isIOS ? Configuration.chatUrl : Configuration.chatUrl,
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": true,
        });
    msgProv.socket = socket;
    socket.connect();
    _connectSocket();
    // ignore: unnecessary_set_literal
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          Provider.of<MessageProvider>(context, listen: false).getMessageChart(
              clientId: widget.receiver,
              userModel: widget.userId,
              roomId: '',
              productId: widget.productId)
        });
  }

  _connectSocket() {
    var msgProv = Provider.of<MessageProvider>(context, listen: false);

    msgProv.socket.onConnectError((data) {
      log('Connect Error: $data');
      log('Connect Error');
    });
    msgProv.socket.onDisconnect((data) {
      log('DISCONNECT');
    });
    msgProv.socket.emit("add-user", msgProv.roomModel!.sId);
    msgProv.socket.onConnect((data) {
      log('Connection established');
      log('Connection established');

      msgProv.socket.on("userConnected", (d) {
        log(d.toString());
      });
      msgProv.socket.on("msg-recieve", (dd) {
        log('GET MESSAGE${dd['message']}');
        MsgModel msgModel = MsgModel(message: dd['message'], fromSelf: false);
        msgProv.addNewMessage(msgModel);
      });
    });
  }

  snackbar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: (Colors.black),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
    if (mounted) {
      socket.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.main,
          title: const Row(
            children: [
              Text(
                'Chat',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: ('Quicksand'),
                    color: Colors.white),
              ),
              Spacer(),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: FooterLayout(
              footer: Container(
                height: 80,
                width: double.maxFinite,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: AppColors.main,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Ionicons.chatbox_ellipses_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 260,
                      height: 50,
                      child: PrimaryTextField(
                        controller: messageController,
                        labelText: " Type your message...",
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () async {
                          if (messageController.text.trim().isNotEmpty) {
                            await _sendMessage();
                          }
                        },
                        icon: Icon(
                          Ionicons.send,
                          color: AppColors.main,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: Consumer<MessageProvider>(
                builder: (_, provider, __) => ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  itemBuilder: (context, index) {
                    final message = provider.messagesList[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                      child: Wrap(
                        alignment: message.fromSelf == true
                            ? WrapAlignment.end
                            : WrapAlignment.start,
                        children: [
                          if (message.fromSelf == true)
                            MyTile(msgModel: message)
                          else
                            ClientTile(msgModel: message),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: provider.messagesList.length,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClientTile extends StatelessWidget {
  final MsgModel msgModel;

  const ClientTile({super.key, required this.msgModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            width: 260,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                color: Colors.grey.withOpacity(0.4)),
            child: Text(msgModel.message.toString(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  final MsgModel msgModel;

  const MyTile({super.key, required this.msgModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              width: 260,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    // bottomRight: Radius.circular(16)
                  ),
                  color: Colors.grey.withOpacity(0.1)),
              child: Text(msgModel.message.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
            ),
          ],
        ));
  }
}
