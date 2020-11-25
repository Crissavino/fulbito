import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/player.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/screens/chats/chat_room_screen.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:provider/provider.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  // MessageBloc messageBloc = MessageBloc();
  ChatRoomService _chatRoomService;
  List<ChatRoom> _allChatRooms;
  AuthService _authService;
  User _currentUser;
  bool loading;
  SocketService _socketService;

  @override
  void initState() {
    this._chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
    this._authService = Provider.of<AuthService>(context, listen: false);
    this._socketService = Provider.of<SocketService>(context, listen: false);
    this._currentUser = this._authService.user;
    _loadChatRooms();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadChatRooms() async {
    this.loading = true;
    this._chatRoomService.allChatRooms = await this._chatRoomService.getAllMyChatRooms(this._currentUser.id);
    this._allChatRooms = this._chatRoomService.allChatRooms;
    setState(() {
      this.loading = false;
    });
  }

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
          child: this.loading
            ? Center(
              child: circularLoading,
            )
            : _buildChatRoomList(),
        ),
      ),
    );
  }

  _buildChatRoomList() {
    if(this._allChatRooms.isEmpty){

      return Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            'Todavia no tienes ningun chat',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'OpenSans',
            ),
          )
      );

    } else {
      return ListView.builder(
        itemCount: (this._allChatRooms != null) ? this._allChatRooms.length : 0,
        itemBuilder: (BuildContext context, int index) {
          final ChatRoom chat = this._allChatRooms[index];
          return _buildChatRoomRow(context, chat, _chatRoomService);
        },
      );
    }

  }

  GestureDetector _buildChatRoomRow(
      BuildContext context, ChatRoom chat, ChatRoomService chatRoomService) {
    return GestureDetector(
      onTap: () async {
        chatRoomService.selectedChatRoom = chat;
        this._socketService.socket.emit('enterChatRoom', {
          'chatRoom': chat,
          'user': this._currentUser,
        });
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
