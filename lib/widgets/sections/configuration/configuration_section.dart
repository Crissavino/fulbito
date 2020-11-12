import 'package:flutter/material.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:provider/provider.dart';

class ConfigurationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              _logoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final SocketService _socketService = Provider.of<SocketService>(context);

    return FlatButton.icon(
      icon: Icon(Icons.logout),
      label: Text('logout'),
      onPressed: () async {
        _socketService.disconnect();
        await _authService.logout();
        Navigator.pushReplacementNamed(context, 'login');
      },
    );
  }
}
