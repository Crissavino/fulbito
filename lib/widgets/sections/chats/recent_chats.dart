import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/models/device.dart';
import 'package:fulbito/models/player.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/screens/chats/chat_room_screen.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:fulbito/widgets/sections/chats/chat_room_rc.dart';
import 'package:provider/provider.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> with TickerProviderStateMixin {
  ChatRoomService _chatRoomService;
  List<ChatRoom> _allChatRooms = [];
  List<ChatRoomRC> _allMyChatRooms = [];
  AuthService _authService;
  User _currentUser;
  dynamic _currentDevice;
  bool loading;
  SocketService _socketService;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    this._chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
    this._authService = Provider.of<AuthService>(context, listen: false);
    this._socketService = Provider.of<SocketService>(context, listen: false);
    this._currentUser = this._authService.user;
    this._currentDevice = this._authService.device;

    this._socketService.socket.on('chatRoomMessage-recentChats', _receiveChatRoomMessage);
    this._socketService.socket.on('newChatRoom-recentChats', _chatRoomCreated);
    this._socketService.socket.on('leaveChatRoom-recentChats', _leaveChatRoomData);
    _loadChatRooms();
    super.initState();
  }

  @override
  void dispose() {
    for (ChatRoomRC chat in _allMyChatRooms) {
      chat.animationController.dispose();
    }
    this._socketService.socket.off('chatRoomMessage-recentChats');
    this._socketService.socket.off('newChatRoom-recentChats');
    this._socketService.socket.off('leaveChatRoom-recentChats');
    super.dispose();
  }

  void _leaveChatRoomData(dynamic payload) {
    ChatRoomRC chatRC = this._allMyChatRooms.where((ChatRoomRC chatRC) => chatRC.chat.id == payload['chatRoom']['_id']).first;
    chatRC.chat.lastMessage = payload['chatRoom']['lastMessage'];

    final newChatRoomRC = ChatRoomRC(
      chat: chatRC.chat,
      currentUser: this._currentUser,
      currentDevice: this._currentDevice,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 0),
      ),
      socketService: this._socketService,

    );

    final chatPosition = this._allMyChatRooms.indexWhere((ChatRoomRC chatRoomRC) => chatRoomRC.chat.id == chatRC.chat.id);
    this._allMyChatRooms.removeWhere((ChatRoomRC chatRoomRC) => chatRoomRC.chat.id == chatRC.chat.id);
    setState(() {
      this._allMyChatRooms.insert(chatPosition, newChatRoomRC);
    });

    newChatRoomRC.animationController.forward();

    this._focusNode.requestFocus();

  }

  void _chatRoomCreated(dynamic payload) {
    final newChatRoomRC = ChatRoomRC(
        chat: ChatRoom.fromJson(payload['newChatRoom']),
        currentUser: this._currentUser,
        currentDevice: this._currentDevice,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 800),
        ),
      socketService: this._socketService,
    );

    setState(() {
      this._allMyChatRooms.insert(0, newChatRoomRC);
    });

    newChatRoomRC.animationController.forward();

    this._focusNode.requestFocus();

  }

  void _receiveChatRoomMessage(dynamic payload) {

    ChatRoomRC chatRC = this._allMyChatRooms.where((ChatRoomRC chatRC) => chatRC.chat.id == payload['messageDevice']['chatRoom']['_id']).first;
    chatRC.chat.lastMessage = payload['messageDevice'];

    // TODO revisar por que aparece mal el NEW del mensaje

    bool isFirstChatRoom = this._allMyChatRooms[0].chat.id == payload['messageDevice']['chatRoom']['_id'];
    final newChatRoomRC = ChatRoomRC(
      chat: chatRC.chat,
      currentUser: this._currentUser,
      currentDevice: this._currentDevice,
      animationController: AnimationController(
        vsync: this,
        duration: isFirstChatRoom ? Duration(milliseconds: 0) : Duration(milliseconds: 300),
      ),
      socketService: this._socketService,

    );

    this._allMyChatRooms.removeWhere((ChatRoomRC chatRoomRC) => chatRoomRC.chat.id == chatRC.chat.id);

    setState(() {
      this._allMyChatRooms.insert(0, newChatRoomRC);
    });

    newChatRoomRC.animationController.forward();

    this._focusNode.requestFocus();

  }

  void _loadChatRooms() async {
    this.loading = true;
    List<ChatRoom> myChatRooms = await this._chatRoomService.getAllMyChatRooms(this._currentUser.id);
    final history = myChatRooms.map(
        (chat) => ChatRoomRC(
          chat: chat,
          currentUser: this._currentUser,
          currentDevice: this._currentDevice,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(
              milliseconds: 0,
            ),
          )..forward(),
          socketService: this._socketService,

        )
    );

    this.loading = false;
    setState(() {
      this._allMyChatRooms.insertAll(0, history);
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
    if(this._allMyChatRooms.isEmpty){
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
    }
    return ListView.builder(
      itemCount: this._allMyChatRooms.length,
      itemBuilder: (BuildContext context, int index) => this._allMyChatRooms[index],
    );
  }

}
