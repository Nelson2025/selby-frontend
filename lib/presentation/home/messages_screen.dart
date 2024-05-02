import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selby/models/chat_model.dart';
import 'package:selby/presentation/chat/message_screen.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessageProvider>(context, listen: false);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(30.0),
              //   topRight: Radius.circular(30.0),
              // ),
            ),
            child: ClipRRect(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(10.0),
              //   topRight: Radius.circular(10.0),
              // ),
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message chat = chats[index];
                  return GestureDetector(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      final userId = preferences.get('userId');
                      // sourceChat = chats.removeAt(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MessageScreen(
                            userId: userId.toString(),
                            receiver: "",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 5.0, right: 10.0, left: 10.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: chat.unread
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage:
                                    AssetImage('assets/images/selby_logo.png'),
                              ),
                              SizedBox(width: 15.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    chat.sender.name,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      chat.text,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                chat.time,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              chat.unread
                                  ? Container(
                                      width: 40.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'NEW',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
