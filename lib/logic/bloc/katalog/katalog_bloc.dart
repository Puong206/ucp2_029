import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'katalog_event.dart';
part 'katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  KatalogBloc() : super(KatalogInitial()) {
    on<KatalogEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
