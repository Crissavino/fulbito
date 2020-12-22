import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fulbito/globals/constants.dart';
import 'package:fulbito/globals/mostrar_alerta.dart';
import 'package:fulbito/globals/translations.dart';
import 'package:fulbito/screens/auth/signin_screen.dart';
import 'package:fulbito/services/auth_service.dart';
import 'package:fulbito/services/socket_service.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _rememberMe = false;
  bool cantSeePassword = true;
  bool cantSeeConfirmPassword = true;
  String localeName = Platform.localeName.split('_')[0];

  Text _buildPageTitle() {
    return Text(
      translations[localeName]['signUp'],
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFullNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          translations[localeName]['fullName'],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              hintText: translations[localeName]['enterFullName'],
              hintStyle: kHintTextStyle,
            ),
            onChanged: (val) {
              setState(() => fullName = val);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          translations[localeName]['email'],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.grey,
              ),
              hintText: translations[localeName]['enterEmail'],
              hintStyle: kHintTextStyle,
            ),
            onChanged: (val) {
              setState(() => email = val);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          translations[localeName]['password'],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: cantSeePassword,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            onChanged: (val) {
              setState(() {
                password = val;
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (cantSeePassword) {
                      cantSeePassword = false;
                    } else {
                      cantSeePassword = true;
                    }
                  });
                },
              ),
              hintText: translations[localeName]['enterPass'],
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          translations[localeName]['confirmPassword'],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: cantSeeConfirmPassword,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
            onChanged: (val) {
              setState(() => confirmPassword = val);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (cantSeeConfirmPassword) {
                      cantSeeConfirmPassword = false;
                    } else {
                      cantSeeConfirmPassword = true;
                    }
                  });
                },
              ),
              hintText: translations[localeName]['enterConfirmPassword'],
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterBtn() {
    final _authService = Provider.of<AuthService>(context);
    final _socketService = Provider.of<SocketService>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _authService.authenticating
            ? null
            : () async {
                if (fullName.isEmpty) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['mandatoryFullName']
                  );
                } else if (email.isEmpty) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['mandatoryEmail']
                  );
                } else if (password.isEmpty) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['mandatoryPass']
                  );
                } else if (password.length < 6) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['passWithMoreSix']
                  );
                } else if (confirmPassword.isEmpty) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['mandatoryConfirmPass']
                  );
                } else if (confirmPassword.length < 6) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['passWithMoreSix']
                  );
                } else if (password != confirmPassword) {
                  mostrarAlerta(
                      context,
                      translations[localeName]['registerFails'],
                      translations[localeName]['passNotMatch']
                  );
                } else {
                  final registerResp = await _authService.register(
                      this.fullName, this.email, this.password);
                  if (registerResp == true) {
                    await _socketService.connect(_authService.user);
                    Navigator.pushReplacementNamed(context, 'chats');
                  } else {
                    mostrarAlerta(
                        context,
                        translations[localeName]['registerFails'],
                        translations[localeName]['invalidCredentials']
                    );
                  }
                }
              },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => SigninScreen(),
            transitionDuration: Duration(milliseconds: 0),
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Do you have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration: verticalGradient,
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildPageTitle(),
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildFullNameTF(),
                            SizedBox(height: 10.0),
                            _buildEmailTF(),
                            SizedBox(height: 10.0),
                            _buildPasswordTF(),
                            SizedBox(height: 10.0),
                            _buildConfirmPasswordTF(),
                            SizedBox(height: 20.0),
                            // _buildRememberMeCheckbox(),
                            _buildRegisterBtn(),
                            SizedBox(height: 10.0),
                            _buildSignInBtn()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
