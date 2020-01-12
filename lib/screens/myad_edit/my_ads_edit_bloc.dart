import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/model/media.dart';



class UpdateAdEvent {}

class UpdateAdState {}

class UpdateAd extends UpdateAdEvent{
  var adId , adTitle , adDescription , adCityId , adLatitude , adLongitude , adPhone ;

  UpdateAd({this.adId,this.adTitle,this.adDescription,this.adCityId,this.adLongitude,this.adLatitude,this.adPhone});
}

class AddProductEdit extends UpdateAdEvent{
  int adId;
  List<Media> mediaList;
  String name , details;
  String oldPrice , newPrice;
  List<Attribute> attributeList;
  int categoryId , brandId;

  AddProductEdit({this.adId,this.mediaList,this.name,this.oldPrice,this.newPrice,this.categoryId,this.brandId,this.attributeList,this.details});
}

class UpdateProduct extends UpdateAdEvent{
  int productId;
  int categoryId;
  String description;
  String regularPrice;
  String salePrice;
  int brandId;
  String title;

  UpdateProduct({this.productId,this.title,this.regularPrice,this.salePrice,this.categoryId,this.brandId,this.description});

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

    else if(event is AddProductEdit){
      yield Loading();

      print("Loading ADD POST TEST");
      print(event.adId);
      print(event.categoryId);
      print(event.details);
      print(event.name);
      print(event.brandId);
      print(event.oldPrice);
      print(event.newPrice);
      print(event.attributeList);
      print(event.mediaList);
      print("Loading ADD POST TEST");

      try {

        List<SelectedAttributes> selectedAttributes = new List();

        event.attributeList.forEach((v) {
          selectedAttributes.add(new SelectedAttributes(
              attribute_id: v.id,
              attributes_group_id: v.groupId,
              value: ''
          ));
        });

        var res = await _repository.postProduct(
            adId: event.adId,
            categoryId: event.categoryId,
            description: event.details,
            title: event.name,
            brandId: event.brandId,
            regularPrice: event.oldPrice,
            salePrice: event.newPrice,
            attributes: selectedAttributes,
            isWholeSale: 0,
            medias: event.mediaList);
        print("ADD POST");
        print('ADD PRODUCT RESPONCE $res');
        if(res.status){
          yield SuccessState();
        }
        else{
          yield FieldState();

        }
      } on DioError catch (error){
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

    else if(event is UpdateProduct){
      yield Loading();

      try {

        var res = await _repository.updateProduct(
            productId: event.productId,
            categoryId: event.categoryId,
            description: event.description,
            title: event.title,
            brandId: event.brandId,
            regularPrice: event.regularPrice,
            salePrice: event.salePrice,
            isWholeSale: 0,
        );
        print("ADD POST");
        print('ADD PRODUCT RESPONCE $res');
        if(res.status){
          yield SuccessState();
        }
        else{
          yield FieldState();
        }
      } on DioError catch (error){
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




