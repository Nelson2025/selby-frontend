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
import 'package:selby/models/chat_model.dart';
import 'package:selby/models/msg_model.dart';
import 'package:selby/presentation/widgets/primary_textfield.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:selby/services/msg_services.dart';

class IndividualChatScreen extends StatefulWidget {
  final String userId;
  final String receiver;
  final String productId;
  // final String roomId;
  const IndividualChatScreen({
    Key? key,
    required this.userId,
    required this.receiver,
    required this.productId,
    // required this.roomId,
  }) : super(key: key);

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;

  _sendMessage() async {
    var msgProv = Provider.of<MessageProvider>(context, listen: false);
    // UserModel userModel =
    //     Provider.of<AuthProvider>(context, listen: false).userModel;
    MessageService messageService = MessageService();
    await Provider.of<MessageProvider>(context, listen: false).sendMessage(
      clientId: widget.receiver,
      userModel: widget.userId,
      message: messageController.text.trim(),
      roomId: '',
      productId: widget.productId,
    );

//     Provider.of<MessageProvider>(context, listen: false).addNewMessage(

// MsgModel(message:  _messageInputController.text.trim(),
// fromSelf: true,
// image: ''

// )
//       );
    messageController.clear();

    //  msgProv.makeImageNull();
  }

  // List<MessageModel> messages = [];
  // @override
  // void initState() {
  //   connect();
  //   super.initState();
  // }

  // void connect() {
  //   socket = IO.io("http://192.168.1.4:7000", <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoConnect": false
  //   });
  //   socket.connect();
  //   socket.onConnect((data) {
  //     print("Socket Connected");
  //     socket.on("message", (msg) {
  //       print(msg);
  //       setMessage("destination", msg["message"]);
  //     });
  //   });

  //   socket.emit("signin", widget.userId);
  //   print(socket.connected);
  // }

  // void sendMessage(String message, String senderId, String receiverId) {
  //   setMessage("source", message);
  //   socket.emit("message",
  //       {"message": message, "senderId": senderId, "receiverId": receiverId});
  // }

  // void setMessage(String type, String message) {
  //   MessageModel messageModel = MessageModel(type, message);
  //   setState(() {
  //     messages.add(messageModel);
  //   });
  // }

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
        }

        // IO.OptionBuilder().setTransports(['websocket'],
        // )
        // .setQuery(
        //     {'username': widget.userModel!.username}).build(),
        );
    msgProv.socket = socket;
    socket.connect();
    _connectSocket();
    // UserModel userModel =
    //     Provider.of<AuthProvider>(context, listen: false).userModel;
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
      print('Connect Error: $data');
      log('Connect Error');
      // ScaffoldMessenger.of(context).showSnackBar(snackbar(data));
    });
    msgProv.socket.onDisconnect((data) {
      log('DISCONNECT');

      // ScaffoldMessenger.of(context).showSnackBar(snackbar(data));
    });
    msgProv.socket.emit("add-user", msgProv.roomModel!.sId);
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connected')));
    msgProv.socket.onConnect((data) {
      log('Connection established');
      print('Connection established');

      msgProv.socket.on("userConnected", (d) {
        log(d.toString());
      });
      msgProv.socket.on("msg-recieve", (dd) {
        log('GET MESSAGE' + dd['message'].toString());
//     Provider.of<AuthProvider>(context, listen: false).addNewMessage(
        MsgModel msgModel = MsgModel(message: dd['message'], fromSelf: false);
        msgProv.addNewMessage(msgModel);

        // ScaffoldMessenger.of(context).showSnackBar(snackbar(dd['message']));
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
    // var msgProv =Provider.of<MessageProvider>(context, listen: false);

    //  msgProv.socket.emit("disconnect", Provider.of<AuthProvider>(context,listen:false).userModel.sId);

    // TODO: implement dispose
    super.dispose();
//  msgProv.socket.emit('disconnect',{
//   "roomId":msgProv.roomModel!.sId
//  });
    //  msgProv.socket.dispose();
    // WidgetsBinding.instance.addPostFrameCallback((_)  => {

    // TODO: implement initState
    if (mounted) {
      socket.dispose();
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.main,
          title: Row(
            children: [
              // Text('Chat'),
              // CircleAvatar(
              //   radius: 20,
              //   backgroundColor: Colors.white.withOpacity(0.3),
              // ),
              // const SizedBox(
              //   width: 15,
              // ),
              const Text(
                'Chat',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: ('Quicksand'),
                    color: Colors.white),
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
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: SafeArea(
            maintainBottomViewPadding: true,
            //height: MediaQuery.of(context).size.height,
            child: FooterLayout(
              footer: Container(
                height: 80,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(30),
                    color: Colors.transparent),
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
                        child: Icon(
                          Ionicons.chatbox_ellipses_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
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
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () async {
                          if (messageController.text.trim().isNotEmpty) {
                            await _sendMessage();
                          }
                        },
                        // onPressed: () {
                        //   sendMessage(messageController.text.trim(),
                        //       widget.userId, widget.receiver);
                        //   messageController.clear();
                        // },
                        icon: Icon(
                          Ionicons.send,
                          color: AppColors.main,
                          size: 30,
                        ),
                      ),
                    ),
                  ],

                  ///thankyou alll of youuuuuu se you next tutorial
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
                  separatorBuilder: (_, index) => SizedBox(
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
      // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
      width: 260,
// height: 58,

      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            width: 260,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    // bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                color: Colors.grey.withOpacity(0.4)),
            child: Text(msgModel.message.toString(),
                style: TextStyle(
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
    return Container(
        //  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        width: 260,
// height: 58,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              width: 260,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    // bottomRight: Radius.circular(16)
                  ),
                  color: Colors.grey.withOpacity(0.1)),
              child: Text(msgModel.message.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
            ),

            //  Text(
            //         msgModel.message.toString(),
            //         style: TextStyle(
            //             fontSize: 17,
            //             fontWeight: FontWeight.w400,
            //         )
            //     ),
          ],
        ));
  }
}
