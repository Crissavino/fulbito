import 'package:flutter/material.dart';
import 'package:fulbito/models/user.dart';

class UpcomingMatches extends StatelessWidget {
  final User user;
  UpcomingMatches({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0, top: 0.0),
            child: Text(
              'Proximos partidos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Container(
            height: 110.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ChatRoom(
                  //       user: favorites[index],
                  //     ),
                  //   ),
                  // ),
                  onTap: () => print('Debo ir al partido'),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                AssetImage('assets/matches/placeholder.png')),
                        SizedBox(height: 4.0),
                        Text(
                          'EDLP $index',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
