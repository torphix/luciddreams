// UI
import 'package:flutter/material.dart';
// Logic
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luciddreams/bloc/auth/auth_cubit.dart';
import 'package:luciddreams/ui/auth/register.dart';

import '../../bloc/auth/login_cubit.dart';
import '../../common/loading_status.dart';
import '../../common/snackbar.dart';
import '../../common/widgets/curved_widget.dart';
import '../../common/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(),
        child: _loginScreenStyles(context),
      ),
    );
  }

  Widget _loginScreenStyles(context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.lightBlue, Colors.blue],
      )),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            CurvedWidget(
              child: Container(
                padding: const EdgeInsets.only(top: 100, left: 50),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 230),
              child: _loginForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loadingStatus is LoadingFailed) {
          showSnackBar(context, state.loadingStatus!.exception.toString());
        } else if (state.loadingStatus is LoadingSuccess) {
          context.read<AuthCubit>().setLoginState(true);
        }
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emailField(),
                _passwordField(),
                _submitButton(),
                // _googleLogin(),
                _signUpNavButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintStyle: TextStyle(color: Colors.white),
            icon: Icon(Icons.person, color: Colors.white),
            hintText: "Email",
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: !_passwordVisible, //This will obscure text dynamically

        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.lock, color: Colors.white),
          hintText: "Password",
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) => state.isValidPassword ? null : "Invalid Email",
        onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
      );
    });
  }

  Widget _submitButton() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
        child: GradientButton(
          colorOne: Colors.indigo,
          width: 150,
          height: 45,
          onPressed: () {
            context.read<LoginCubit>().loginWithEmail();
          },
          text: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Widget _googleLogin() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: GradientButton(
          colorOne: Colors.indigo,
          width: 150,
          height: 45,
          onPressed: () => {}, // context.read<LoginCubit>().loginWithGoogle(),
          text: const Text(
            'Google',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // icon: const Icon(FontAwesomeIcons.google, color: Colors.white)
        ),
      );
    });
  }

  Widget _signUpNavButton(context) {
    return GradientButton(
      colorOne: Colors.indigo,
      width: 150,
      height: 45,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterView(),
          ),
        );
      },
      text: const Text(
        'Register',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
