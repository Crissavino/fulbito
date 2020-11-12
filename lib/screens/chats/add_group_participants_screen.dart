import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/models/user.dart';
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
  dynamic search = '';
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
                setState(() {
                  search = val;
                });
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
          leading: leadingArrowDown(context),
          actions: [
            _buildMoveForwardIconButton(context),
          ],
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
                      child: SearchPlayerToAddToNewGroup(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  IconButton _buildMoveForwardIconButton(BuildContext context) {
    UsersService usersService = Provider.of<UsersService>(context);
    bool thereAreUsersToAdd = usersService.selectedSearchedUsers.isEmpty;
    return IconButton(
      icon: Icon(Icons.arrow_forward_ios),
      color: Colors.white,
      onPressed: thereAreUsersToAdd
          ? null
          : () {
              Navigator.pushNamed(context, 'create-new-group');
            },
    );
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
