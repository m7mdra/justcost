import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/user_sessions.dart';
import 'ad.dart';
import 'package:justcost/data/exception/exceptions.dart';

abstract class AdEvent {}

abstract class AdState {}

class PostAdEvent extends AdEvent {
  final AdDetails adDetails;
  final AdContact adContact;
  final List<AdProduct> products;
  final bool isWholeSale;

  PostAdEvent(this.adDetails, this.adContact, this.products, this.isWholeSale);
}

class LoadingState extends AdState {
  final String message;
  final String percentage;

  LoadingState(this.message, this.percentage);
}

class ErrorState extends AdState {}

class IdleState extends AdState {}

class NetworkErrorState extends AdState {}

class SuccessState extends AdState {}

class PostAdFailed extends AdState {}

class AdBloc extends Bloc<AdEvent, AdState> {
  final AdRepository _repository;
  final UserSession _session;

  AdBloc(this._repository, this._session);

  @override
  AdState get initialState => IdleState();

  @override
  Stream<AdState> mapEventToState(AdEvent event) async* {
    if (event is PostAdEvent) {
      yield LoadingState("Please wait while trying to submit your ad", "%0");
      final userId = await _session.userId();
      try {
        final response = await _repository.postAd(
            customerId: userId,
            cityId: event.adContact.city.id,
            lat: event.adContact.location.latitude,
            lng: event.adContact.location.longitude,
            mobile: event.adContact.phoneNumber,
            title: event.adDetails.title,
            isWholeSale: event.isWholeSale ? 1 : 0,
            description: event.adDetails.description,
            progressCallback: (count, total) async* {
              yield LoadingState("Please wait while trying to submit your ad",
                  "${(total - count) / (total * 100)}%");
            });
        if (response.success) {
          yield LoadingState("Uploading Media...", "%0");
        } else {
          yield PostAdFailed();
        }
      } on DioError catch (error) {} on SessionExpired {} catch (error) {}
    }
  }
}
