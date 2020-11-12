import 'package:flutter/material.dart';
import 'package:fulbito/screens/auth/signin_screen.dart';
import 'package:fulbito/screens/auth/signup_screen.dart';
import 'package:fulbito/screens/chats/chat_info_screen.dart';
import 'package:fulbito/screens/chats/create_new_group.dart';
import 'package:fulbito/screens/container_screen.dart';
import 'package:fulbito/widgets/widgets.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'chats': (_) => ContainerScreen(),
  'login': (_) => SigninScreen(),
  'register': (_) => SignupScreen(),
  'splash': (_) => Splash(),
  'chat-info-screen': (_) => ChatInfoScreen(),
  'create-new-group': (_) => CreateNewGroup(),
};
