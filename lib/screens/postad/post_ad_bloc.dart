import 'dart:async';
import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/ad/model/post_ad_response.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
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

class RetryPostProduct extends AdEvent {
  final List<AdProduct> adProduct;
  final int adId;
  final bool isWholesale;

  RetryPostProduct(this.adProduct, this.adId, this.isWholesale);

  @override
  String toString() {
    return 'RetryPostProduct{adProduct: $adProduct, adId: $adId, isWholesale: $isWholesale}';
  }

}

class LoadingState extends AdState {
  final Loading loading;

  LoadingState(this.loading);
}

enum Loading { ad, product }

class IdleState extends AdState {}

class ErrorState extends AdState {}

class NetworkErrorState extends AdState {}

class CheckUserType extends AdEvent {}

class SavePostAsDraft extends AdEvent {
  final AdDetails adDetails;
  final AdContact adContact;
  final List<AdProduct> products;
  final bool isWholeSale;

  SavePostAsDraft(
      this.adDetails, this.adContact, this.products, this.isWholeSale);

  @override
  String toString() {
    return 'SavePostAsDraft{adDetails: $adDetails, adContact: $adContact, products: $products, isWholeSale: $isWholeSale}';
  }
}

class CheckIfDraftExists extends AdEvent {}

class DraftLoaded extends AdState {
  final AdDetails adDetails;
  final AdContact adContact;
  final List<AdProduct> products;
  final bool isWholeSale;

  DraftLoaded(this.adDetails, this.adContact, this.products, this.isWholeSale);
}

class GoatUserState extends AdState {}

class NormalUserState extends AdState {}

class PostProductsFailed extends AdState {
  final List<AdProduct> products;
  final int adId;
  final bool isWholeSale;

  PostProductsFailed(this.products, this.adId, this.isWholeSale);
}

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
    if (event is CheckUserType) {
      if (await _session.isUserAGoat())
        yield GoatUserState();
      else
        yield NormalUserState();
    }
    if (event is SavePostAsDraft) {}
    if (event is PostAdEvent) {
      yield LoadingState(Loading.ad);
      final userId = await _session.userId();
      try {
        final response = await _repository.postAd(
            customerId: userId,
            cityId: event.adContact.city.id,
            facebookAccount: event.adContact.facebookAccount,
            twitterAccount: event.adContact.twitterAccount,
            snapchatAccount: event.adContact.snapchatAccount,
            instagramAccount: event.adContact.instagramAccount,
            lat: event.adContact.location.latitude,
            lng: event.adContact.location.longitude,
            mobile: event.adContact.phoneNumber,
            title: event.adDetails.title,
            isWholeSale: event.isWholeSale ? 1 : 0,
            description: event.adDetails.description);
        if (response.success) {
          var products = event.products;
//          var products = event.products;
//          prefix0.print(object);
          yield* postProducts(products, event.isWholeSale, response.data);
        } else {
          yield PostAdFailed();
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
    if (event is RetryPostProduct) {
      var products = event.adProduct;
      print(event);
      yield* postProducts(products, event.isWholesale, event.adId);
    }
  }

  Stream<AdState> postProducts(
      List<AdProduct> products, bool isWholesale, int adid) async* {
    for (var i = 0; i < products.length; i++) {
      yield LoadingState(Loading.product);

      prefix0.print("Loading ADD POST TEST");
      prefix0.print(products[i].category.id);
      prefix0.print(products[i].details);
      prefix0.print(products[i].name);
      prefix0.print(products[i].brand.id);
      prefix0.print(products[i].quantity);
      prefix0.print(products[i].oldPrice);
      prefix0.print(products[i].newPrice);
      prefix0.print(products[i].attributes);
      prefix0.print(adid);
      prefix0.print(products[i].mediaList);
      prefix0.print("Loading ADD POST TEST");

      try {

        List<SelectedAttributes> selectedAttributes = new List();

        products[i].attributes.forEach((v) {
          selectedAttributes.add(new SelectedAttributes(
              attribute_id: v.id,
              attributes_group_id: v.groupId,
              value: ''
          ));
        });

        var res = await _repository.postProduct(
            categoryId: products[i].category.id,
            description: products[i].details,
            title: products[i].name,
            brandId: products[i].brand.id,
            quantity: isWholesale ? products[i].quantity : "0",
            regularPrice: products[i].oldPrice,
            salePrice: products[i].newPrice,
            isPaid: 0,
            attributes: selectedAttributes,
            isWholeSale: isWholesale ? 1 : 0,
            adId: adid,
            medias: products[i].mediaList);
        prefix0.print("ADD POST");
        print(res);
        if (!res.status) failedRequest.add(products[i]);
        if (i == products.length - 1) {
          yield SuccessState();
          break;
        }
      } on DioError {
        yield PostProductsFailed(failedRequest, adid, isWholesale);
        break;
      } on SessionExpired {
        yield SessionExpiredState();
        break;
      } catch (error) {
        yield PostProductsFailed(failedRequest, adid, isWholesale);
        break;
        print(error);
      }
    }
  }
}
