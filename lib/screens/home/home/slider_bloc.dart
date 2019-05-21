import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/home/home_repository.dart';

abstract class SliderEvent {}

abstract class SliderState {}

class LoadSlider extends SliderEvent {}

class SliderIdle extends SliderState {}

class SliderLoaded extends SliderState {
  final List<String> sliders;

  SliderLoaded(this.sliders);
}

class SliderLoading extends SliderState {}

class SliderError extends SliderState {}

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final HomeRepository repository;

  SliderBloc(this.repository);
  @override
  SliderState get initialState => SliderIdle();

  @override
  Stream<SliderState> mapEventToState(SliderEvent event) async* {
    if (event is LoadSlider) {
      try {
        yield SliderLoading();
        var response = await repository.getHomeSlider();
        if (response.success) yield SliderLoaded(response.data);
        else yield SliderError();
      } on DioError catch (error) {
        yield SliderError();
      } catch (err) {
        yield SliderError();
      }
    }
  }
}
