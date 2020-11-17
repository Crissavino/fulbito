part of 'widgets.dart';

class HorizontalAddedPlayers extends StatefulWidget {

  @override
  _HorizontalAddedPlayersState createState() => _HorizontalAddedPlayersState();
}

class _HorizontalAddedPlayersState extends State<HorizontalAddedPlayers> {
  UsersService usersService;
  List<User> addedUsers;

  @override
  void initState() {
    this.usersService = Provider.of<UsersService>(context, listen: false);
    this.addedUsers = this.usersService.selectedSearchedUsers;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(


        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: this.addedUsers.length,
        itemBuilder: (BuildContext context, int index) {
          final player = this.addedUsers[index];

          return _buildPlayerAvatar(player);
        },
      ),
    );
  }

  CircleAvatar _buildPlayerAvatar(User player) {
    return CircleAvatar(
      radius: 35.0,
      backgroundImage: NetworkImage(
        // user.imageUrl
        'https://img2.freepng.es/20180228/grw/kisspng-logo-football-photography-vector-football-5a97847a010f99.3151271415198792900044.jpg',
      ),
    );
  }
}
