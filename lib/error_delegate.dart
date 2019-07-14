import 'package:bloc/bloc.dart';

class GlobalAppBlocDelegate extends BlocDelegate {
  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print("****************BLOC ERROR****************");
    print("****************${bloc.runtimeType}*********************");
    print("*****************Error********************");
    print(error);
    print("*****************Stacktrack********************");
    print(stacktrace);
    print("****************BLOC ERROR****************");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print("****************TRANSITION****************");
    print("****************$bloc*********************");
    print(transition);
    print("****************TRANSITION****************");
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print("****************EVENT****************");
    print("****************${bloc.runtimeType}*********************");
    print(event);
    print("****************${bloc.runtimeType}****************");
  }
}
