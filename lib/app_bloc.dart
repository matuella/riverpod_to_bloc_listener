import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/////////////////////
/// AppBloc Events///
/////////////////////
@immutable
abstract class AppEvent {}

class AppRequestedSignIn extends AppEvent {
  final String username;

  AppRequestedSignIn(this.username);
}

class AppSignedOut extends AppEvent {}

/////////////////////
/// AppBloc States///
/////////////////////
@immutable
abstract class AppState extends Equatable {
  @override
  List<Object> get props => [];
}

class AppUnauthenticated extends AppState {}

class AppAuthenticating extends AppState {
  AppAuthenticating();
}

class AppAuthenticated extends AppState {
  final String user;

  AppAuthenticated(this.user);
}

///////////////
/// AppBloc ///
///////////////
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppUnauthenticated());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppRequestedSignIn) {
      yield* _mapAppRequestedSignInToState(event);
    } else if (event is AppSignedOut) {
      yield AppUnauthenticated();
    }
  }

  Stream<AppState> _mapAppRequestedSignInToState(AppRequestedSignIn event) async* {
    yield AppAuthenticating();
    await Future.delayed(const Duration(seconds: 1));

    yield AppAuthenticated(event.username);
  }
}
