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
  AuthService authService;
  ChatRoomService chatRoomService;
  User currentUser;

  @override
  void initState() {
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
    this.currentUser = this.authService.usuario;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UsersService usersService =
        Provider.of<UsersService>(context, listen: false);
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
            _buildAddPlayerToNewGroupIcon(context, usersService)
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
    List<User> usersToAdd = usersService.selectedSearchedUsers;
    print('asdasd');
    return IconButton(
      icon: usersToAdd.contains(widget.userInRow)
          ? Icon(
              Icons.check,
              color: Colors.blue,
            )
          : Icon(Icons.add_circle_outline),
      iconSize: 30.0,
      color: Colors.green[400],
      onPressed: () {
        bool isAlreadySelected = usersToAdd
            .where((User user) => user.id == widget.userInRow.id)
            .isNotEmpty;

        if (!isAlreadySelected) {
          usersToAdd.add(widget.userInRow);
          usersService.selectedSearchedUsers = usersToAdd;
        } else {
          usersToAdd.remove(widget.userInRow);
          usersService.selectedSearchedUsers = usersToAdd;
        }
      },
    );
  }
}
