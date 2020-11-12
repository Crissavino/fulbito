import 'package:flutter/material.dart';

// const NGROK_HTTP = 'https://4186ef62e043.ngrok.io';
const NGROK_HTTP = 'http://localhost:4000';
// ngrok http 4000

final kHintTextStyle = TextStyle(
  color: Colors.grey,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.grey[100],
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

final screenBorders = BorderRadius.only(
  topLeft: Radius.circular(30.0),
  topRight: Radius.circular(30.0),
);

final horizontalGradient = BoxDecoration(
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
);

final verticalGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.green[400],
      Colors.green[500],
      Colors.green[600],
      Colors.green[800],
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  ),
);

final circularLoading = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[400]),
  strokeWidth: 2.0,
);

IconButton leadingArrowDown(BuildContext context) => IconButton(
      icon: Icon(
        Icons.keyboard_arrow_down,
        size: 35,
      ),
      padding: EdgeInsets.only(top: 4.0),
      onPressed: () => Navigator.pop(context),
    );

// constantes generales
const CREATE = 'Crear';
const PARTICIPANTS = 'Participantes';
const ENTER_A_NAME = 'Ingresa un nombre';

// constantes del grupo
const ADD_PLAYER = 'Agregar jugador';
const CREATE_GAME = 'Crear partido';
const LEAVE_GROUP = 'Abandonar el grupo';
const CREATE_GROUP = 'Crear grupo';
const ADD_PARTICIPANTS = 'Agregar jugadores';
const GROUP_NAME = 'Nombre del grupo';

// constantes del partido
const ADD_PLAYER_TO_MATCH = 'Agregar jugador';
const EDIT_MATCH = 'Editar partido';
const LEAVE_MATCH = 'Abandonar partido';
const DELETE_MATCH = 'Eliminar partido';

final List<String> chatRoomMenuChoices = <String>[
  ADD_PLAYER,
  CREATE_GAME,
];

final List<String> matchMenuChoices = <String>[
  ADD_PLAYER_TO_MATCH,
  EDIT_MATCH,
  LEAVE_MATCH,
  DELETE_MATCH
];
