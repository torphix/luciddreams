// UI
import 'package:flutter/material.dart';
// Logic
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luciddreams/bloc/auth/register_cubit.dart';

import '../../common/loading_status.dart';
import '../../common/snackbar.dart';
import '../../common/widgets/curved_widget.dart';
import '../../common/widgets/gradient_button.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      body: BlocProvider<RegisterCubit>(
        create: (context) => RegisterCubit(),
        child: Container(
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
                      'Register',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: _signUpForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpForm(context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.loadingStatus is LoadingFailed) {
          showSnackBar(context, state.loadingStatus!.exception.toString());
        }
        if (state.loadingStatus is LoadingSuccess) {
          showSnackBar(context, 'Please check your email for verification');
          Navigator.pop(context);
        }
      },
      builder: (contex, state) {
        // if (state.loadingStatus is LoadingInProgress) {
        // return LoadingView();
        // }
        return Container(
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
                  _loginNavButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
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
          icon: Icon(Icons.person, color: Colors.white),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) => state.isValidEmail ? null : "Invalid Email",
        onChanged: (value) => context.read<RegisterCubit>().emailChanged(value),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
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
        onChanged: (value) =>
            context.read<RegisterCubit>().passwordChanged(value),
      );
      // context.read<RegisterCubit>().passwordChanged(value));
    });
  }

  Widget _submitButton() {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: GradientButton(
            colorOne: Colors.indigo,
            width: 150,
            height: 45,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<RegisterCubit>().register();
              }
            },
            text: const Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ));
    });
  }

  Widget _loginNavButton(context) {
    return GradientButton(
      colorOne: Colors.indigo,
      width: 150,
      height: 45,
      onPressed: () {
        // Pop as only should be able
        // To navigate from login
        Navigator.pop(context);
      },
      text: const Text(
        'Login',
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
