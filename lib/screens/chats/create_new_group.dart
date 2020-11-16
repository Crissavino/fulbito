import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';

class CreateNewGroup extends StatefulWidget {
  @override
  _CreateNewGroupState createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String groupName = '';

  Widget _buildGroupNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          GROUP_NAME,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.only(left: 30.0),
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: GROUP_NAME,
              hintStyle: kHintTextStyle,
            ),
            validator: (val) => val.isEmpty ? ENTER_A_NAME : null,
            onChanged: (val) {
              setState(() => groupName = val);
            },
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
        ),
        body: Container(
          decoration: horizontalGradient,
          child: Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: screenBorders,
              ),
              child: ClipRRect(
                borderRadius: screenBorders,
                child: Container(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildGroupNameTF(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Divider(
                                  thickness: 3.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    PARTICIPANTS,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                // GridViewPlayers(
                                //   usersToAddToGroup:
                                //   widget.usersToAddToGroup,
                                //   userBloc: widget.userBloc,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Text _buildPageTitle() {
    return Text(
      CREATE_GROUP,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
