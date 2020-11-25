import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/device_message.dart';
import 'package:fulbito/models/message.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/screens/chats/add_group_participants_screen.dart';
import 'package:fulbito/screens/chats/chat_info_screen.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:fulbito/widgets/sections/chats/chat_message.dart';
import 'package:fulbito/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with TickerProviderStateMixin {
  String textMessage;
  final TextEditingController _textController = TextEditingController();
  ChatRoomService _chatRoomService;
  AuthService _authService;
  ChatRoom chatRoom;
  User currentUser;
  dynamic currentDevice;
  SocketService socketService;
  List<ChatMessage> _messages = [];
  bool isLoading = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    this._authService = Provider.of<AuthService>(context, listen: false);
    this.currentUser = this._authService.user;
    this.currentDevice = this._authService.device;
    print(this.currentDevice);
    this._chatRoomService =
        Provider.of<ChatRoomService>(context, listen: false);

    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.socketService.socket?.on('mensaje-personal', _escucharMensaje);
    this.socketService.socket?.on('chatRoomMessage', _receiveMessage);
    this.socketService.socket?.on('newUserEnter', (payload) {
      print(payload);
    });

    this.chatRoom = this._chatRoomService.selectedChatRoom;
    _textController.addListener(_getLatestValue);
    _cargarHistorial();
    super.initState();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    _textController.dispose();
    // Clean up the controller when the widget is removed from the
    // widget tree.
    this.socketService.socket.off('mensaje-personal');
    this.socketService.socket.off('newUserEnter');
    this.socketService.socket.off('chatRoomMessage');
    // this.socketService.socket.dispose();
    super.dispose();
  }

  _getLatestValue() {
    setState(() {
      textMessage = _textController.text;
    });
  }

  PopupMenuButton<String> _buildPopupMenu() {
    return PopupMenuButton<String>(
      offset: Offset(-20, 10),
      onSelected: choiceAction,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      icon: Icon(
        Icons.add_circle_outline,
        size: 30.0,
      ),
      padding: EdgeInsets.only(
        right: 10.0,
      ),
      itemBuilder: (BuildContext context) {
        return chatRoomMenuChoices.map((String choice) {
          return PopupMenuItem(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice) async {
    if (choice == ADD_PLAYER) {
      await Navigator.push(
        context,
        SlideBottomRoute(
          page: AddGroupParticipantsScreen(),
        ),
      );
    } else if (choice == CREATE_GAME) {
      print('Tocaste crear partido');
    }
  }

  GestureDetector _openChatInfo(BuildContext context, ChatRoom chatRoom) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'chat-info-screen'),
      child: Text(
        chatRoom.name,
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            decoration: horizontalGradient,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                title: _openChatInfo(context, _chatRoomService.selectedChatRoom),
                elevation: 0.0,
                leading: leadingArrowDown(context),
                flexibleSpace: Container(
                  decoration: horizontalGradient,
                ),
                actions: <Widget>[
                  _buildPopupMenu(),
                ],
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: screenBorders,
                      ),
                      child: ClipRRect(
                        borderRadius: screenBorders,
                        child: (this.isLoading)
                            ? Center(
                          child: circularLoading,
                        )
                            : _buildMessagesScreen(),
                      ),
                    ),
                  ),
                  _buildMessageComposer(),
                ],
              ),
            ),
          ),
          ),
      ],
    );
  }

  _handleSubmit() {
    if (this.textMessage.length == 0) {
      return;
    }

    final newMessage = ChatMessage(
      text: this.textMessage,
      sender: this.currentUser,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    this._messages.insert(0, newMessage);
    // desp de insertar el mensaje disparo la animacion
    newMessage.animationController.forward();

    this.socketService.socket.emit('chatRoomMessage', {
      'sender': this.currentUser,
      'senderDevice': this.currentDevice,
      'chatRoom': this.chatRoom,
      'text': this.textMessage
    });

    this._focusNode.requestFocus();
    this._textController.clear();
  }

  void _receiveMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
      text: payload['text'],
      sender: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 400,
        ),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }


  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.photo),
          //   iconSize: 25.0,
          //   color: Colors.green[400],
          //   onPressed: () {},
          // ),
          SizedBox(
            width: 25.0,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar mensaje...',
              ),
              focusNode: _focusNode,
            ),
          ),
          Platform.isIOS
              ? CupertinoButton(
            child: Text(
              'Enviar',
              style: TextStyle(
                  color: Colors.green[400]
              ),
            ),
            onPressed: () => _handleSubmit(),
          )
              :
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.green[400],
            onPressed: () => _handleSubmit(),
          ),
        ],
      ),
    );
  }

  void _cargarHistorial() async {
    this.isLoading = true;
    List<DeviceMessage> myMessages = await this
        ._chatRoomService
        .getAllMyChatRoomMessages(this.chatRoom.id, this.currentUser.id);
    final history = myMessages.map(
      (m) => ChatMessage(
        text: m.text,
        sender: m.sender,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(
            milliseconds: 0,
          ),
        )..forward(),
      ),
    );

    this.isLoading = false;
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  Widget _buildMessagesScreen() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(top: 15.0),
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int index) => _messages[index]
          // _buildItem(_messages[index], currentUser),
          ),
    );
  }

  void _escucharMensaje(dynamic payload) {
    print(payload);

    ChatMessage message = ChatMessage(
      text: payload['mensaje'],
      sender: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 400,
        ),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }
}
