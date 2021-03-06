import 'package:flutter/material.dart';
import 'package:fulbito/models/user.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final dynamic sender;
  final String time;
  final AnimationController animationController;

  const ChatMessage({
    Key key,
    @required this.text,
    @required this.sender,
    @required this.time,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User currentUser = authService.user;
    final userId = this.sender is User ? this.sender.id : this.sender['_id'];

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ),
        child: Container(
          child: userId == currentUser.id
              ? _myMessage(context, currentUser)
              : _notMyMessage(context, this.sender),
          // : _notMyMessage(context, sender),
        ),
      ),
    );
  }

  Widget _myMessage(BuildContext context, User currentUser) {
    final DateTime parsedTime = DateTime.tryParse(this.time);
    final messageHour = parsedTime.hour;
    final messageMinute = parsedTime.minute < 10 ? '0${parsedTime.minute}' : parsedTime.minute;
    final messageTime = '$messageHour:$messageMinute';
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 50.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentUser.fullName,
                // message.time.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                messageTime.toString(),
                // message.time.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            this.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notMyMessage(BuildContext context, dynamic senderUser) {
    final userFullName = senderUser is User ? senderUser.fullName : senderUser['fullName'];
    final DateTime parsedTime = DateTime.tryParse(this.time);
    final messageHour = parsedTime.hour;
    final messageMinute = parsedTime.minute < 10 ? '0${parsedTime.minute}' : parsedTime.minute;
    final messageTime = '$messageHour:$messageMinute';
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userFullName,
                // message.time.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                messageTime.toString(),
                // message.time.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            this.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
