import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:provider/provider.dart';

class MatchesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: screenBorders,
      ),
      child: ClipRRect(
        borderRadius: screenBorders,
        child: _buildMatchesList(context),
      ),
    );
  }

  FutureBuilder<List<ChatRoom>> _buildMatchesList(BuildContext context) {
    final ChatRoomService _chatRoomService = ChatRoomService();
    final User currentUser = Provider.of<AuthService>(context).usuario;
    return FutureBuilder(
      future: _chatRoomService.getAllMyChatRooms(currentUser.firebaseId),
      builder: (context, futureChats) {
        if (futureChats.hasData) {
          final List<ChatRoom> chats = futureChats.data;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final ChatRoom chat = chats[index];
              return _buildMatch(context, chat);
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

  GestureDetector _buildMatch(BuildContext context, ChatRoom chat) {
    return GestureDetector(
      onTap: () => {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ChatRoom(
        //       chatRoom: chat,
        //       currentUser: user,
        //     ),
        //   ),
        // );
      },
      child: _botonesRedondeados(),
    );
  }

  Widget _botonesRedondeados() {
    return Table(
      children: [
        TableRow(children: [
          _crearBotonRedondeado(Colors.green, Icons.sports_soccer, 'Partido'),
        ]),
      ],
    );
  }

  Widget _crearBotonRedondeado(Color color, IconData icon, String text) {
    return ClipRRect(
      child: Container(
        height: 180.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.green[100].withOpacity(0.7),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 5.0,
            ),
            CircleAvatar(
              radius: 35.0,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 30.0),
            ),
            Text(text, style: TextStyle(color: color)),
            SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
    );
  }
}
