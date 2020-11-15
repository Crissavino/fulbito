part of 'widgets.dart';

class PlayerRowToNewGroup extends StatefulWidget {
  final User userInRow;

  const PlayerRowToNewGroup({
    this.userInRow,
  });
  @override
  _PlayerRowToNewGroupState createState() => _PlayerRowToNewGroupState();
}

class _PlayerRowToNewGroupState extends State<PlayerRowToNewGroup> {
  UsersService usersService;
  List<User> addedUsers;

  @override
  void initState() {
    // TODO: implement initState
    this.usersService = Provider.of<UsersService>(context, listen: false);
    this.addedUsers = this.usersService.selectedSearchedUsers;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 2.0, right: 10.0, left: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFEFEE),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPlayerAvatar(),
            _buildPlayerName(),
            _buildAddPlayerToNewGroupIcon(context, this.usersService)
          ],
        ),
      ),
    );
  }

  CircleAvatar _buildPlayerAvatar() {
    return CircleAvatar(
      radius: 35.0,
      backgroundImage: NetworkImage(
        // user.imageUrl
        'https://img2.freepng.es/20180228/grw/kisspng-logo-football-photography-vector-football-5a97847a010f99.3151271415198792900044.jpg',
      ),
    );
  }

  Text _buildPlayerName() {
    return Text(
      widget.userInRow.fullName,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  IconButton _buildAddPlayerToNewGroupIcon(
      BuildContext context, UsersService usersService) {

    bool isAlreadySelected = this.addedUsers
        .where((User user) => user.id == widget.userInRow.id)
        .isNotEmpty;

    return IconButton(
      icon: isAlreadySelected
          ? Icon(
              Icons.check,
              color: Colors.blue,
            )
          : Icon(Icons.add_circle_outline),
      iconSize: 30.0,
      color: Colors.green[400],
      onPressed: () {
        if (!isAlreadySelected) {
          usersService.selectedSearchedUsers = widget.userInRow;
        } else {
          usersService.removeSelectedUser(widget.userInRow);
        }
      },
    );
  }
}
