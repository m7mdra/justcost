import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/attribute/attribute_repository.dart';
import 'package:justcost/data/attribute/model/attribute.dart';

abstract class AttributesEvent {}

abstract class AttributesState {}

class LoadProductAttribute extends AttributesEvent {
  final int productId;

  LoadProductAttribute(this.productId);
}

class AttributesLoaded extends AttributesState {
  final List<Attribute> attributes;

  AttributesLoaded(this.attributes);
}

class AttributesNetworkError extends AttributesState {}

class AttributesError extends AttributesState {}

class AttributesLoading extends AttributesState {}

class AttributesBloc extends Bloc<AttributesEvent, AttributesState> {
  final AttributeRepository _repository;

  AttributesBloc(this._repository);

  @override
  AttributesState get initialState => AttributesLoading();

  @override
  Stream<AttributesState> mapEventToState(AttributesEvent event) async* {
    if (event is LoadProductAttribute) {
      yield AttributesLoading();
      try {
        var response =
            await _repository.getAttributesForProduct(event.productId);
        if (response.success)
          yield AttributesLoaded(response.attributes);
        else
          yield AttributesError();
      } on DioError {
        yield AttributesNetworkError();
      } catch (error) {
        yield AttributesError();
      }
    }
  }
}
