import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/attribute/attribute_repository.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';

class AttributeFilterEvent {}

class AttributeFilterState {}

class LoadAttributes extends AttributeFilterEvent {
  final int categoryId;

  LoadAttributes(this.categoryId);
}

class AttributesLoadingState extends AttributeFilterState {}

class AttributesEmptyState extends AttributeFilterState {}

class AttributesNetworkErrorState extends AttributeFilterState {}

class AttributesErrorState extends AttributeFilterState {}

class AttributesLoaded extends AttributeFilterState {
  final List<AttributeGroup> attributeGroupList;

  AttributesLoaded(this.attributeGroupList);
}

class FilterAttributeBloc
    extends Bloc<AttributeFilterEvent, AttributeFilterState> {
  AttributeRepository _repository;

  FilterAttributeBloc(this._repository);

  @override
  AttributeFilterState get initialState => AttributesLoadingState();

  @override
  Stream<AttributeFilterState> mapEventToState(
      AttributeFilterEvent event) async* {
    if (event is LoadAttributes) {
      try {
        var response =
            await _repository.getAttributeForCategory(event.categoryId);
        if (response.success) {
          if (response.attributeGroupList.isNotEmpty)
            yield AttributesLoaded(response.attributeGroupList);
          else
            yield AttributesEmptyState();
        }
      } on DioError {
        yield AttributesNetworkErrorState();
      } catch (error) {
        yield AttributesErrorState();
      }
    }
  }
}
