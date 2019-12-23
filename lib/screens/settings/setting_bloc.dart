import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

class SettingEvent {}

class SettingState {}

class ChangeLanguage extends SettingEvent {
  final String languageCode;

  ChangeLanguage(this.languageCode);
}

class LanguageChanged extends SettingState {
  final String languageCode;

  LanguageChanged(this.languageCode);
}

class LoadCurrentLanguage extends SettingEvent {}

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final UserSession _session;

  SettingBloc(this._session);

  @override
  SettingState get initialState => SettingState();

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is ChangeLanguage) {
      await _session.saveLanguage(event.languageCode);
      yield LanguageChanged(event.languageCode);
    }
    if (event is LoadCurrentLanguage) {
      yield LanguageChanged(await _session.getCurrentLanguage());
    }
  }

}
