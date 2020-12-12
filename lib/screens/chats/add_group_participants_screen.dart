import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/mostrar_alerta.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:fulbito/services/users_service.dart';
import 'package:fulbito/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddGroupParticipantsScreen extends StatefulWidget {
  @override
  _AddGroupParticipantsScreenState createState() =>
      _AddGroupParticipantsScreenState();
}

class _AddGroupParticipantsScreenState
    extends State<AddGroupParticipantsScreen> {
  UsersService usersService;
  ChatRoomService chatRoomService;
  AuthService authService;
  SocketService _socketService;
  User _currentUser;

  @override
  void dispose() {
    // TODO: implement dispose
    this._socketService.socket.off('players-added-to-chatroom');
    super.dispose();
  }

  @override
  void initState() {
    this.usersService = Provider.of<UsersService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this._currentUser = this.authService.user;
    this.chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
    this._socketService = Provider.of<SocketService>(context, listen: false);

    super.initState();
  }

  Widget _buildSearchTF() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 30.0,
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.grey[700],
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: -3),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search',
                hintStyle: kHintTextStyle,
              ),
              onChanged: (val) {
                this.usersService.termSearched = val;
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _buildPageTitle(),
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: horizontalGradient,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 35,
            ),
            padding: EdgeInsets.only(top: 4.0),
            onPressed: () {
              this.usersService.emptySelectedUsersArray();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          decoration: horizontalGradient,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: _buildSearchTF(),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: screenBorders,
                    ),
                    child: ClipRRect(
                      borderRadius: screenBorders,
                      child: SearchPlayerToAddToGroup(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 15.0, left: 15.0, right: 15.0, bottom: 50.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    elevation: 2.0,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      // agregar jugadores al grupo y vaciar el arreglo
                      final addPlayersResponse = await this
                          .chatRoomService
                          .addPlayersToGroup(
                              this._currentUser,
                              this.usersService.selectedSearchedUsers,
                              this.chatRoomService.selectedChatRoom.id);

                      if (addPlayersResponse['success'] == true) {
                        this
                            ._socketService
                            .socket
                            .emit('usersAddedToChatRoom', {
                          'chatRoom': this.chatRoomService.selectedChatRoom,
                          'addedUsers': this.usersService.selectedSearchedUsers
                        });
                        this.chatRoomService.selectedChatRoom = ChatRoom.fromJson(addPlayersResponse['chatRoom']);
                        this.usersService.emptySelectedUsersArray();
                        Navigator.pop(context);
                      } else {
                        mostrarAlerta(context, 'Ups...',
                            'Ocurrio un error al agregar los jugadores');
                      }
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    child: Text(
                      'AGREGAR',
                      style: TextStyle(
                        color: Colors.green[400],
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Text _buildPageTitle() {
    return Text(
      ADD_PARTICIPANTS,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
