import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user_sessions.dart';


class UpdateAdEvent {}

class UpdateAdState {}

class UpdateAd extends UpdateAdEvent{
  var adId , adTitle , adDescription , adCityId , adLatitude , adLongitude , adPhone ;

  UpdateAd({this.adId,this.adTitle,this.adDescription,this.adCityId,this.adLongitude,this.adLatitude,this.adPhone});
}


class Loading extends UpdateAdState{}

class IdleState extends UpdateAdState {}

class ErrorState extends UpdateAdState {}

class NetworkErrorState extends UpdateAdState {}

class SuccessState extends UpdateAdState {}

class FieldState extends UpdateAdState {}

class SessionExpiredState extends UpdateAdState {}

class UpdateAdBloc extends Bloc<UpdateAdEvent, UpdateAdState> {
  final AdRepository _repository;
  final UserSession _session;

  UpdateAdBloc(this._repository, this._session);

  @override
  UpdateAdState get initialState => IdleState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Stream<UpdateAdState> mapEventToState(UpdateAdEvent event) async* {
    if (event is UpdateAd) {
      yield Loading();
      final userId = await _session.userId();
      try {
        final response = await _repository.updateAd(
            adId: event.adId,
            customerId: userId,
//            cityId: event.adCityId,
            lat: event.adLatitude,
            lng: event.adLongitude,
            mobile: event.adPhone,
            title: event.adTitle,
            description: event.adDescription);
        print(response.toString());
        if (response.success) {
          yield SuccessState();
        } else {
          yield FieldState();
        }
      } on DioError catch (error) {
        print(error);
        yield NetworkErrorState();
      } on SessionExpired {
        await _session.clear();
        yield SessionExpiredState();
      } catch (error) {
        print(error);
        yield ErrorState();
      }
    }
  }

}




