import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

class NotificationEvent {}

class NotificationState {}

class LoadNotificationState extends NotificationEvent{
  String token;
  LoadNotificationState({this.token});
}

class ActiveNotificationEvent extends NotificationEvent{
  String token;
  ActiveNotificationEvent({this.token});
}

class DisActiveNotificationEvent extends NotificationEvent{
  String token;
  DisActiveNotificationEvent({this.token});
}


class IdleNotificationState extends NotificationState{}

class LoadingState extends NotificationState{}

class ActiveNotificationState extends NotificationState{}

class DisActiveNotificationState extends NotificationState{}

class ErrorNotificationState extends NotificationState{}

class SessionExpiredState extends NotificationState{}

class NetworkErrorState extends NotificationState{}


class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final UserRepository _repository;

  NotificationBloc(this._repository);

  @override
  NotificationState get initialState => IdleNotificationState();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is LoadNotificationState) {
      try {
        yield LoadingState();
        var response = await _repository.loadNotificationState(event.token);
        if (response['success']){
          yield ActiveNotificationState();
        } else {
          yield ErrorNotificationState();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError catch(error){
        print('Error ${error.response.data}');
        if(!error.response.data['success']){
          yield DisActiveNotificationState();
          return;
        }
        yield NetworkErrorState();
        print(error);
      } catch (error) {
        print(error);
        yield ErrorNotificationState();
      }
    }

    if (event is ActiveNotificationEvent) {
      try {
        var response = await _repository.registerFirebaseToken(event.token);
        if (response['success']){
          yield ActiveNotificationState();
        } else {
          yield ErrorNotificationState();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError catch(error){
        yield NetworkErrorState();
        print(error);
      } catch (error) {
        print(error);
        yield ErrorNotificationState();
      }
    }

    if (event is DisActiveNotificationEvent) {
      try {
        var response = await _repository.removeFirebaseToken(event.token);
        if (response['success']){
          yield DisActiveNotificationState();
        } else {
          yield ErrorNotificationState();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError catch(error){
        yield NetworkErrorState();
        print(error);
      } catch (error) {
        print(error);
        yield ErrorNotificationState();
      }
    }
  }


}
