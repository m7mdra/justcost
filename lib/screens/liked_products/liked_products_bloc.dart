import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class LikedEvent {}

abstract class LikedState {}

class LoadMyLikes extends LikedEvent {}

class LoadingState extends LikedState {}

class EmptyState extends LikedState {}

class ErrorState extends LikedState {}

class NetworkErrorState extends LikedState {}

class MyLikesLoaded extends LikedState {
  final List<Product> products;

  MyLikesLoaded(this.products);
}

class SessionExpiredState extends LikedState {}

class LikedProductBloc extends Bloc<LikedEvent, LikedState> {
  final ProductRepository _repository;

  LikedProductBloc(this._repository);

  @override
  LikedState get initialState => LoadingState();

  @override
  Stream<LikedState> mapEventToState(LikedEvent event) async* {
    if (event is LoadMyLikes) {
      yield LoadingState();
      try {
        var response = await _repository.getLikedProduct();
        if (response.success) {
          if (response.data.isEmpty) {
            yield EmptyState();
          } else {
            yield MyLikesLoaded(response.data);
          }
        } else {
          yield ErrorState();
        }
      } on DioError {
        yield NetworkErrorState();
      } on SessionExpired {
        yield SessionExpiredState();
      } catch (error) {
        if (error is SocketException)
          yield NetworkErrorState();
        else
          yield ErrorState();
      }
    }
  }
}
