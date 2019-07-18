import 'dart:async';

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
class RetryPostProduct extends AdEvent{
  final List<AdProduct> adProduct;
  final int adId;

  RetryPostProduct(this.adProduct, this.adId);
}

class LoadingState extends AdState {
  final String message;

  LoadingState(this.message);
}

class ErrorState extends AdState {}

class IdleState extends AdState {}

class NetworkErrorState extends AdState {}

class SuccessState extends AdState {}

class PostAdFailed extends AdState {}

class SessionExpiredState extends AdState {}


class AdBloc extends Bloc<AdEvent, AdState> {
  final AdRepository _repository;
  final UserSession _session;
  List<AdProduct> failedRequest = [];

  AdBloc(this._repository, this._session);

  @override
  AdState get initialState => IdleState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Stream<AdState> mapEventToState(AdEvent event) async* {
    if (event is PostAdEvent) {
      yield LoadingState("Please wait while trying to submit your ad");
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
            description: event.adDetails.description);
        if (response.success) {
          var products = event.products;

          for (var i = 0; i < products.length; i++) {
            yield LoadingState("Submitting product #$i...");
            try {
              await _repository.postProduct(
                  categoryId: products[i].category.id,
                  description: products[i].details,
                  title: products[i].name,
                  brandId: products[i].brand.id,
                  quantity: event.isWholeSale ? products[i].quantity : "0",
                  regularPrice: products[i].oldPrice,
                  salePrice: products[i].newPrice,
                  isPaid: 0,
                  attributes: products[i]
                      .attributes
                      .map((attribute) => attribute.id)
                      .toList(),
                  isWholeSale: event.isWholeSale ? 1 : 0,
                  adId: response.data,
                  medias: products[i].mediaList);

              if (i == products.length - 1) {
                yield SuccessState();
                break;
              }
            } on DioError catch (error) {
              yield NetworkErrorState();

            } on SessionExpired {
              yield SessionExpiredState();
            } catch (error) {
              yield ErrorState();

            }
          }
        } else {
          yield PostAdFailed();
        }
      } on DioError catch (error) {
        print(error);
        yield NetworkErrorState();
      } on SessionExpired {
        yield SessionExpiredState();
      } catch (error) {
        print(error);
        yield ErrorState();
      }
    }
  }
}
