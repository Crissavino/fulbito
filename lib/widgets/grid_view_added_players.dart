part of 'widgets.dart';

class GridViewAddedPlayers extends StatefulWidget {
  @override
  _GridViewAddedPlayersState createState() => _GridViewAddedPlayersState();
}

class _GridViewAddedPlayersState extends State<GridViewAddedPlayers> {

  UsersService usersService;
  List<User> addedUsers;

  @override
  Widget build(BuildContext context) {
    this.usersService = Provider.of<UsersService>(context);
    this.addedUsers = this.usersService.selectedSearchedUsers;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
          itemCount: this.addedUsers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // number of items per row
            crossAxisCount: 3,
            // vertical spacing between the items
            mainAxisSpacing: 10,
            // horizontal spacing between the items
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: NetworkImage(
                            'https://img2.freepng.es/20180228/grw/kisspng-logo-football-photography-vector-football-5a97847a010f99.3151271415198792900044.jpg'),
                      ),
                      Text(
                        this.addedUsers[index].fullName
                            .split(' ')[0],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -6,
                  right: 5,
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    iconSize: 28.0,
                    color: Colors.red[300],
                    onPressed: () {
                      this.usersService.removeSelectedUser(this.addedUsers[index]);
                      if(this.addedUsers.length < 1) {
                        Navigator.pop(context);
                        return;
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
