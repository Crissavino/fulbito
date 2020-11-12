import 'package:flutter/material.dart';
import 'package:fulbito/widgets/sections/chats/recent_chats.dart';
import 'package:fulbito/widgets/sections/chats/upcoming_matches.dart';

class ChatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          UpcomingMatches(),
          RecentChats(),
        ],
      ),
    );
  }
}
