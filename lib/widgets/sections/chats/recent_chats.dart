import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/screens/chats/chat_room_screen.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:provider/provider.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  // MessageBloc messageBloc = MessageBloc();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: screenBorders,
        ),
        child: ClipRRect(
          borderRadius: screenBorders,
          child: _buildChatRoomList(),
        ),
      ),
    );
  }

  _buildChatRoomList() {
    final ChatRoomService _chatRoomService =
        Provider.of<ChatRoomService>(context);
    final User currentUser = Provider.of<AuthService>(context).usuario;
    return FutureBuilder(
      future: _chatRoomService.getAllMyChatRooms(currentUser.firebaseId),
      builder: (BuildContext context,
          AsyncSnapshot<List<ChatRoom>> futureChatRooms) {
        if (futureChatRooms.hasData) {
          final List<ChatRoom> chats = futureChatRooms.data;

          return ListView.builder(
            itemCount: (chats != null) ? chats.length : 0,
            itemBuilder: (BuildContext context, int index) {
              final ChatRoom chat = chats[index];
              return _buildChatRoomRow(context, chat, _chatRoomService);
            },
          );
        } else {
          return Center(
            child: circularLoading,
          );
        }
      },
    );
  }

  GestureDetector _buildChatRoomRow(
      BuildContext context, ChatRoom chat, ChatRoomService chatRoomService) {
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
                  '15:00',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                chat.unreadMessages
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
