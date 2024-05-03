/*This is the Chats Screen*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/room_model.dart';
import 'package:selby/presentation/chat/individual_chat_screen.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String userId = "";

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId').toString();
    });
  }

  @override
  void initState() {
    getUserId();
    setState(() {
      userId;
    });
    super.initState();
  }

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
            ),
            child: ClipRRect(
              child: FutureBuilder(
                  future: provider.fetchRoomsById(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<RoomModel> cdata = snapshot.data;

                      return ListView.builder(
                        itemCount: cdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return (cdata[index].lastUser.toString() == '')
                              ? null
                              : GestureDetector(
                                  onTap: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    final userId = preferences.get('userId');
                                    Navigator.push(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IndividualChatScreen(
                                                    // roomId: cdata[index].sId.toString(),
                                                    productId: cdata[index]
                                                        .results['_id']
                                                        .toString(),
                                                    userId: userId.toString(),
                                                    receiver: cdata[index]
                                                                .users!
                                                                .last
                                                                .toString() ==
                                                            userId
                                                        ? cdata[index]
                                                            .users!
                                                            .first
                                                            .toString()
                                                        : cdata[index]
                                                            .users!
                                                            .last
                                                            .toString())));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 5.0,
                                        right: 10.0,
                                        left: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: NetworkImage(
                                                  '${Configuration.imageUrl}${cdata[index].results['image'][0].toString()}'),
                                            ),
                                            const SizedBox(width: 15.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                (userId.toString() ==
                                                        "${cdata[index].senderDetails?['_id'].toString()}")
                                                    ? (("${cdata[index].receiverDetails?['name'].toString()}" ==
                                                            '')
                                                        ? const Text(
                                                            "Selby User",
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: Color
                                                                  .fromARGB(
                                                                      137,
                                                                      43,
                                                                      35,
                                                                      35),
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : Text(
                                                            "${cdata[index].receiverDetails?['name'].toString()}",
                                                            style:
                                                                const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: Color
                                                                  .fromARGB(
                                                                      137,
                                                                      43,
                                                                      35,
                                                                      35),
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ))
                                                    : (("${cdata[index].senderDetails?['name'].toString()}" ==
                                                            '')
                                                        ? const Text(
                                                            "Selby User",
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: Color
                                                                  .fromARGB(
                                                                      137,
                                                                      43,
                                                                      35,
                                                                      35),
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : Text(
                                                            "${cdata[index].senderDetails?['name'].toString()}",
                                                            style:
                                                                const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: Color
                                                                  .fromARGB(
                                                                      137,
                                                                      43,
                                                                      35,
                                                                      35),
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )),
                                                const SizedBox(height: 5.0),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    cdata[index]
                                                        .results['title']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black87,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    cdata[index]
                                                        .results['description']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black87,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            const SizedBox(height: 5.0),
                                            (cdata[index]
                                                            .msgStatus
                                                            .toString() ==
                                                        'new' &&
                                                    cdata[index]
                                                            .lastUser
                                                            .toString() !=
                                                        userId)
                                                ? Container(
                                                    width: 40.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'NEW',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                      );
                    }
                  }),
            ),
          ),
        ),
      ],
    ));
  }
}
