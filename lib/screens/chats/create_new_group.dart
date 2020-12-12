import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/mostrar_alerta.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:fulbito/services/users_service.dart';
import 'package:fulbito/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../container_screen.dart';

class CreateNewGroup extends StatefulWidget {
  @override
  _CreateNewGroupState createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String groupName = '';
  bool isLoading = false;
  SocketService _socketService;

  Widget _buildGroupNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          GROUP_NAME,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.only(left: 30.0),
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: GROUP_NAME,
              hintStyle: kHintTextStyle,
            ),
            validator: (val) => val.isEmpty ? ENTER_A_NAME : null,
            onChanged: (val) {
              setState(() => groupName = val);
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    this._socketService = Provider.of<SocketService>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          actions: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(right: 20.0),
                child: Center(
                  child: GestureDetector(
                    child: Text(
                      CREATE,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        final chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
                        final currentUser = Provider.of<AuthService>(context, listen: false).user;
                        final currentDevice = Provider.of<AuthService>(context, listen: false).device;
                        final usersService = Provider.of<UsersService>(context, listen: false);
                        final usersToAddToGroup = usersService.selectedSearchedUsers;

                        setState(() {
                          this.isLoading = true;
                        });

                        dynamic createChatRoomResponse = await chatRoomService.createChatRoom(
                          currentUser,
                          currentDevice,
                          groupName,
                          usersToAddToGroup,
                        );

                        setState(() {
                          this.isLoading = false;
                        });

                        if (createChatRoomResponse['success'] == true) {
                          usersService.emptySelectedUsersArray();

                          this._socketService.socket.emit('newChatRoom', {
                            'chatRoom': createChatRoomResponse['chatRoom']
                          });

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => ContainerScreen(),
                              ),
                                  (route) => false);
                        } else {
                          // if not created
                          mostrarAlerta(context, 'Ups...',
                              createChatRoomResponse['message']);
                        }
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          decoration: horizontalGradient,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: screenBorders,
            ),
            child: ClipRRect(
              borderRadius: screenBorders,
              child: Container(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: this.isLoading
                      ? Container(
                        alignment: Alignment.center,
                        height: 500.0,
                        child: Center(
                          child: circularLoading,
                        ),
                      )
                      : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGroupNameTF(),
                              SizedBox(
                                height: 30.0,
                              ),
                              Divider(
                                thickness: 3.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  PARTICIPANTS,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              // HorizontalAddedPlayers(),
                              GridViewAddedPlayers(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Text _buildPageTitle() {
    return Text(
      CREATE_GROUP,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
