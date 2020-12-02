import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/models/chat_room.dart';
import 'package:fulbito/services/chat_room_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  final bool isNameEdited;

  const EditText({
    @required this.isNameEdited,
  });
  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final TextEditingController _textController = TextEditingController();
  ChatRoomService _chatRoomService;
  ChatRoom chatRoom;

  // text field state
  String textEdited;

  _getLatestValue() {
    setState(() {
      textEdited = _textController.text;
    });
  }

  @override
  void initState() {
    this._chatRoomService =
        Provider.of<ChatRoomService>(context, listen: false);
    this.chatRoom = this._chatRoomService.selectedChatRoom;
    if (widget.isNameEdited) {
      textEdited = chatRoom.name;
    } else {
      textEdited = chatRoom.description;
    }
    _textController.addListener(_getLatestValue);
    _textController.text = textEdited;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _textController.dispose();
    super.dispose();
  }

  Widget _buildTextEditTF(textEdited) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _textController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _textController.clear();
                },
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0, left: 20.0),
              hintText:
              widget.isNameEdited ? GROUP_NAME : 'Descripcion del grupo',
              hintStyle: kHintTextStyle,
            ),
            validator: widget.isNameEdited
                ? (val) => val.isEmpty ? 'Ingrese un nombre del grupo' : null
                : (val) =>
            val.isEmpty ? 'Ingrese una descripcion del grupo' : null,
            onChanged: (val) {
              setState(() => textEdited = val);
            },
          ),
        ),
      ],
    );
  }

  Widget divider() {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Divider(
        thickness: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canSave = (textEdited.isEmpty ||
        this._chatRoomService.selectedChatRoom.name == textEdited ||
        this._chatRoomService.selectedChatRoom.name == textEdited.trim());

    return Container(
      decoration: horizontalGradient,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          // backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: widget.isNameEdited ? Text('Nombre') : Text('Descripcion'),
            elevation: 0.0,
            leading: leadingArrowDown(context),
            flexibleSpace: Container(
              decoration: horizontalGradient,
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 20.0),
                child: Center(
                  child: GestureDetector(
                    onTap: canSave
                        ? null
                        : () async {
                            dynamic resp;
                            if (widget.isNameEdited) {
                              resp = await this
                                  ._chatRoomService
                                  .editGroupName(this.chatRoom, textEdited);
                            } else {
                              resp = await this
                                  ._chatRoomService
                                  .editGroupDescription(
                                      this.chatRoom, textEdited);
                            }
                            if (resp['success']) {
                              Navigator.pop(context);
                            } else {
                              print('Algo fallo');
                            }
                          },
                    child: canSave
                        ? Opacity(
                            opacity: 0.5,
                            child: Text('Guardar'),
                          )
                        : Text('Guardar'),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: screenBorders,
              ),
              child: ClipRRect(
                borderRadius: screenBorders,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: _buildTextEditTF(textEdited),
                    ),
                    divider(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
