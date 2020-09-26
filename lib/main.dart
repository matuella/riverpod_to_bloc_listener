import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod_to_bloc_listener/app_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AppBloc(),
      child: SideEffectsBlocApp(),
    ),
  );
}

class SideEffectsBlocApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (previous, current) => current is AppAuthenticated || current is AppUnauthenticated,
      listener: (context, state) {
        if (state is AppAuthenticated) {
          navigatorKey.currentState.pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignedInPage(state.user),
              fullscreenDialog: true,
            ),
          );
        } else if (state is AppUnauthenticated) {
          navigatorKey.currentState.pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignInPage(),
              fullscreenDialog: true,
            ),
          );
        }
      },
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          home: SignInPage(),
        );
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) => current is AppAuthenticating || current is AppUnauthenticated,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blue.shade100,
          body: Center(
            child: RaisedButton(
              onPressed: () {
                context.bloc<AppBloc>().add(AppRequestedSignIn('anyUsername'));
              },
              child: state is AppUnauthenticated ? Text('Sign In Event') : CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class SignedInPage extends StatelessWidget {
  final String signedInUser;
  SignedInPage(this.signedInUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: RaisedButton(
          onPressed: () {
            context.bloc<AppBloc>().add(AppSignedOut());
          },
          child: Text('Sign out from $signedInUser'),
        ),
      ),
    );
  }
}
