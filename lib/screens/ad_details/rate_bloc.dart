import 'package:bloc/bloc.dart';
import 'package:justcost/data/rate/rate_repository.dart';

class RateBloc extends Bloc<RateEvent, RateState> {
  final RateRepository _repository;

  RateBloc(this._repository);

  @override
  RateState get initialState => RateState();

  @override
  Stream<RateState> mapEventToState(RateEvent event) async* {
    if (event is LoadRates) {
      try {
        var rateResponse = await _repository.getProductRate(event.productId);
        var rate = rateResponse.rate;
        yield RateLoaded(rate.count, rate.rate);
      } catch (error) {}
    }
    if (event is RateProduct) {
      try {
        var responseStatus =
            await _repository.rateProduct(event.productId, event.rate);
        if (responseStatus.status) {
          add(LoadRates(event.productId));
          yield RatedSuccess();
        }
      } catch (error) {}
    }
  }
}

class RateState {}

class RateLoaded extends RateState {
  final int count, rate;

  RateLoaded(this.count, this.rate);
}

class RatedSuccess extends RateState {}

class RateEvent {}

class RateProduct extends RateEvent {
  final int productId;
  final int rate;

  RateProduct(this.productId, this.rate);
}

class LoadRates extends RateEvent {
  final int productId;

  LoadRates(this.productId);
}
