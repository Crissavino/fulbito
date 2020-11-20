import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:fulbito/widgets/edit_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatInfoScreen extends StatefulWidget {
  @override
  _ChatInfoScreenState createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  File _groupImage;
  final picker = ImagePicker();
  ChatRoomService _chatRoomService;

  @override
  void initState() {
    this._chatRoomService =
        Provider.of<ChatRoomService>(context, listen: false);
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _groupImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final availableWidth = mediaQuery.size.width - 160;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildGroupName(),
                divider(),
                _buildGroupDesc(),
                divider(),
              ],
            ),
          ),
          _buildGroupParticipants(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                divider(),
                _buildLeaveGroup(),
                divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Divider(
        thickness: 1.0,
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final mediaQuery = MediaQuery.of(context);

    final availableWidth = mediaQuery.size.width;

    return SliverAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, this._chatRoomService.selectedChatRoom);
          }),
      elevation: 2.0,
      backgroundColor: Colors.green[400],
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      stretch: true,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        // print('constraints=' + constraints.toString());
        var top = constraints.biggest.height;
        return FlexibleSpaceBar(
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: top < 110.0 ? 1.0 : 0.0,
            child: Text(
              this._chatRoomService.selectedChatRoom.name,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          background: Stack(
            children: [
              Container(
                width: availableWidth,
                height: mediaQuery.size.height,
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  image: (this._chatRoomService.selectedChatRoom.image != null)
                      ? NetworkImage(
                          this._chatRoomService.selectedChatRoom.image)
                      : AssetImage('assets/matches/placeholder.png'),
                  fadeInDuration: Duration(milliseconds: 150),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                width: availableWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white60,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => getImage,
                        color: Colors.white,
                        splashColor: Colors.transparent,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGroupName() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SlideBottomRoute(
            page: EditText(
              isNameEdited: true,
            ),
          ),
        ).then((value) {
          setState(() {});
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          this._chatRoomService.selectedChatRoom.name,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupDesc() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SlideBottomRoute(
            page: EditText(
              isNameEdited: false,
            ),
          ),
        ).then((value) {
          setState(() {});
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          this._chatRoomService.selectedChatRoom.description,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupParticipants() {
    final List players = this._chatRoomService.selectedChatRoom.players;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return InkWell(
            onTap: () =>
                print('Accions con el usuario ${players[index].user.fullName}'),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  CircleAvatar(
                    child: Text(players[index].user.fullName[0]),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    players[index].user.fullName,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: players.length,
      ),
    );
  }

  Widget _buildLeaveGroup() {
    return FlatButton(
      onPressed: () => print('Abandonar grupo'),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          LEAVE_GROUP,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
