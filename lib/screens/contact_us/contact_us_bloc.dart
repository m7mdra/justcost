import 'package:bloc/bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';

class ContactUsEvent {}

class SendReport extends ContactUsEvent {
  String name ,  email ,  subject ,  message;
  SendReport({this.name,this.email,this.subject,this.message});
}

class ContactUsState {}

class IdleState extends ContactUsState {}

class LoadingState extends ContactUsState {}

class NetworkErrorState extends ContactUsState {}

class ErrorState extends ContactUsState {}

class SessionExpiredState extends ContactUsState {}

class SendReportSuccess extends ContactUsState {}


class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final AdRepository _repository;

  ContactUsBloc(this._repository);

  @override
  ContactUsState get initialState => IdleState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
    print(stacktrace);
  }
  @override
  Stream<ContactUsState> mapEventToState(ContactUsEvent event) async* {
    if (event is SendReport) {
      yield LoadingState();
      try {
        var response = await _repository.sendReport(event.name, event.email, event.subject, event.message);
        if (response['success']) {
          yield SendReportSuccess();
        } else {
          yield ErrorState();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError catch(error){
        yield NetworkErrorState();
        print(error);
      } catch (error) {
        print(error);
        yield ErrorState();
      }
    }
  }
}
