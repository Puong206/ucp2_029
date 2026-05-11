import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp2/data/models/katalog_model.dart';

part 'katalog_event.dart';
part 'katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  KatalogBloc() : super(KatalogInitial()) {
    on<KatalogEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
