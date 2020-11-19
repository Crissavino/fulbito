part of 'widgets.dart';

class SearchPlayerToAddToGroup extends StatefulWidget {
  @override
  _SearchPlayerToAddToGroupState createState() => _SearchPlayerToAddToGroupState();
}

class _SearchPlayerToAddToGroupState extends State<SearchPlayerToAddToGroup> {

  AuthService authService;
  UsersService usersService;
  ChatRoomService chatRoomService;
  List<User> usersToAdd;
  ChatRoom chatRoom;

  @override
  void initState() {
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.usersService = Provider.of<UsersService>(context, listen: false);
    this.chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
    this.usersToAdd = this.usersService.selectedSearchedUsers;
    this.chatRoom = this.chatRoomService.selectedChatRoom;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.usersService.getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: circularLoading,
          );
        }
        List<User> userResults;
        final term = this.usersService.termSearched?.toLowerCase();
        if (term != '' && term != null) {
          userResults = snapshot.data
              .where((User user) => user.fullName.toLowerCase().contains(term))
              .toList();
        } else {
          userResults = snapshot.data;
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: userResults.length,
          itemBuilder: (BuildContext context, int index) {
            User user = userResults[index];
            bool isAlreadyInGroup = this.chatRoom.players
                .where((Player player) => player.user.id == userResults[index].id)
                .isNotEmpty;
            if (!isAlreadyInGroup) {
              return PlayerRowToGroup(
                userInRow: user,
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
