import 'package:flutter/material.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/screens/chats/chat_room_screen.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:provider/provider.dart';

class ChatRoomRC extends StatelessWidget {
  final ChatRoom chat;
  final User currentUser;
  final AnimationController animationController;

  const ChatRoomRC({
    Key key,
    @required this.chat,
    @required this.currentUser,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatRoomService = Provider.of<ChatRoomService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.linear,
        ),
        child: Container(
          child: this._buildChatRoomRow(context, chat, chatRoomService),
          // : _notMyMessage(context, sender),
        ),
      ),
    );
  }

  GestureDetector _buildChatRoomRow(
      BuildContext context, ChatRoom chat, ChatRoomService chatRoomService) {
    final DateTime parsedTime = DateTime.tryParse(chat.lastMessage['time']);
    final messageHour = parsedTime.hour;
    final messageMinute = parsedTime.minute < 10 ? '0${parsedTime.minute}' : parsedTime.minute;
    final messageTime = '$messageHour:$messageMinute';
    bool isUnread = chat.lastMessage['unread'];
    print('isUnread');
    print(isUnread);

    return GestureDetector(
      onTap: () async {
        chatRoomService.selectedChatRoom = chat;
        Navigator.push(
          context,
          SlideBottomRoute(
            page: ChatRoomScreen(),
          ),
        );
      },
      child: Container(
        margin:
        EdgeInsets.only(top: 10.0, bottom: 2.0, right: 10.0, left: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage(
                      'https://img2.freepng.es/20180228/grw/kisspng-logo-football-photography-vector-football-5a97847a010f99.3151271415198792900044.jpg'),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chat.name,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        (chat.lastMessage != null)
                            ? chat.lastMessage['text']
                            : '',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15.0,
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
                  messageTime.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                isUnread
                    ? Container(
                  width: 40.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
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
  }

}
