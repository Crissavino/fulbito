import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/slide_bottom_route.dart';
import 'package:fulbito/screens/add_match_info_screen.dart';
import 'package:fulbito/widgets/sections/chats/chats_section.dart';
import 'package:fulbito/widgets/sections/configuration/configuration_section.dart';
import 'package:fulbito/widgets/sections/matches/matches_section.dart';
import 'package:fulbito/widgets/sections/play_now/play_now_section.dart';

import 'chats/add_group_participants_screen.dart';

class ContainerScreen extends StatefulWidget {
  @override
  _ContainerScreenState createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  dynamic search = '';
  int currentIndex = 1;

  Container _buildPlayNowPostButton() {
    return Container(
      padding: const EdgeInsets.only(top: 30.0),
      child: IconButton(
        icon: Icon(Icons.add_circle_outline),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          print('Crear un post para jugar ahora');
        },
      ),
    );
  }

  Container _buildCreateGroupButton() {
    return Container(
      padding: const EdgeInsets.only(top: 30.0),
      child: IconButton(
        icon: Icon(Icons.add_circle_outline),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            SlideBottomRoute(
              page: AddGroupParticipantsScreen(),
            ),
          ).then((val) async {
            setState(() {});
          });
        },
      ),
    );
  }

  Container _buildCreateMatchButton() {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: IconButton(
        icon: Icon(Icons.add_circle_outline),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            SlideBottomRoute(
              page: AddMatchInfoScreen(),
            ),
          ).then((val) async {
            setState(() {});
          });
        },
      ),
    );
  }

  Widget _buildAddButton(int index) {
    switch (index) {
      case 0:
        return _buildPlayNowPostButton();
        break;
      case 1:
        return _buildCreateGroupButton();
        break;
      case 2:
        return _buildCreateMatchButton();
        break;
      case 3:
        return Container();
        break;
      default:
        return _buildCreateGroupButton();
        break;
    }
  }

  Widget _buildSearchTF() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: (currentIndex == 3)
                  ? const EdgeInsets.only(left: 20.0)
                  : const EdgeInsets.only(left: 25.0, right: 25.0),
              margin: EdgeInsets.only(top: 40.0, left: 10.0),
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
              width: (currentIndex == 3)
                  ? MediaQuery.of(context).size.width * 0.95
                  : MediaQuery.of(context).size.width * 0.8,
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
                  hintText: 'Buscar',
                  hintStyle: kHintTextStyle,
                ),
                onChanged: (val) {
                  setState(() => search = val);
                },
              ),
            ),
          ],
        ),
        _buildAddButton(this.currentIndex),
      ],
    );
  }

  _callSection(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return PlayNowSection();
      case 1:
        return SafeArea(
          child: ChatsSection(),
        );
        break;
      case 2:
        return SafeArea(
          child: MatchesSection(),
        );
        break;
      case 3:
        return SafeArea(
          child: ConfigurationSection(),
        );
        break;
      default:
        return SafeArea(
          child: ChatsSection(),
        );
        break;
    }
  }

  Widget _buildBottomNavigationBarRounded() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          iconSize: 25,
          showUnselectedLabels: false,
          selectedItemColor: Colors.green[400],
          unselectedItemColor: Colors.green[900],
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
              title: Text('Juga ya!'),
              icon: Icon(
                Icons.play_arrow_outlined,
              ),
            ),
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
              title: Text('Chats'),
              icon: Icon(Icons.chat_bubble_outline_rounded),
            ),
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
              title: Text('Partidos'),
              icon: Icon(Icons.sports_soccer),
            ),
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
              title: Text('Configuracion'),
              icon: Icon(Icons.brightness_5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarRect() {
    return BottomNavigationBar(
      iconSize: 25,
      showUnselectedLabels: false,
      selectedItemColor: Colors.green[400],
      unselectedItemColor: Colors.green[900],
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          // ignore: deprecated_member_use
          title: Text('Juga ya!'),
          icon: Icon(
            Icons.play_arrow_outlined,
          ),
        ),
        BottomNavigationBarItem(
          // ignore: deprecated_member_use
          title: Text('Chats'),
          icon: Icon(Icons.chat_bubble_outline_rounded),
        ),
        BottomNavigationBarItem(
          // ignore: deprecated_member_use
          title: Text('Partidos'),
          icon: Icon(Icons.sports_soccer),
        ),
        BottomNavigationBarItem(
          // ignore: deprecated_member_use
          title: Text('Configuracion'),
          icon: Icon(Icons.brightness_5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.green[400],
                Colors.green[500],
                Colors.green[600],
                Colors.green[700],
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: _buildSearchTF(),
        ),
      ),
      body: Container(
        decoration: horizontalGradient,
        child: SafeArea(
          child: _callSection(currentIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: (currentIndex != 0)
            ? BoxDecoration(color: Colors.white)
            : horizontalGradient,
        child: _buildBottomNavigationBarRounded(),
      ),
    );
  }
}
