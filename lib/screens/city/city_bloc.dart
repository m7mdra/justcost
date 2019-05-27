import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/city/model/city.dart';

abstract class CitiesEvent {}

abstract class CitiesState {}

class LoadCities extends CitiesEvent {}

class LoadingState extends CitiesState {}

class ErrorState extends CitiesState {}

class NoDataState extends CitiesState {}

class NetworkErrorState extends CitiesState {}

class CitesLoaded extends CitiesState {
  final List<City> cites;

  CitesLoaded(this.cites);
}

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  final CityRepository repository;

  CitiesBloc(this.repository);

  @override
  CitiesState get initialState => LoadingState();

  @override
  Stream<CitiesState> mapEventToState(CitiesEvent event) async* {
    if (event is LoadCities) {
      yield LoadingState();
      try {
        var response = await repository.getCites();
        if (response.success) {
          if (response.data.isEmpty)
            yield NoDataState();
          else
            yield CitesLoaded(response.data);
        } else
          yield ErrorState();
      } on DioError {
        yield NetworkErrorState();
      } catch (error) {
        yield ErrorState();
      }
    }
  }
}
