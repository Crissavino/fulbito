part of 'widgets.dart';

class SearchPlayerToAddToNewGroup extends StatefulWidget {
  @override
  _SearchPlayerToAddToNewGroupState createState() =>
      _SearchPlayerToAddToNewGroupState();
}

class _SearchPlayerToAddToNewGroupState
    extends State<SearchPlayerToAddToNewGroup> {
  AuthService authService;
  UsersService usersService;
  ChatRoomService chatRoomService;
  List<User> usersToAdd;

  @override
  void initState() {
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.usersService = Provider.of<UsersService>(context, listen: false);
    this.chatRoomService = Provider.of<ChatRoomService>(context, listen: false);
    this.usersToAdd = this.usersService.selectedSearchedUsers;

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
          itemCount: userResults.length,
          itemBuilder: (BuildContext context, int index) {
            User user = userResults[index];
            if (user.id != this.authService.user.id) {
              return PlayerRowToNewGroup(
                userInRow: user,
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
