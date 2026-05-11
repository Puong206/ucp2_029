import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/data/repositories/katalog_repository.dart';

part 'katalog_event.dart';
part 'katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final KatalogRepository repository;
  
  KatalogBloc({required this.repository}) : super(KatalogInitial()) {
    on<FetchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final list = await repository.getAllKatalog();
        emit(KatalogLoaded(list));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<CreateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.createKatalog(event.data);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<UpdateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.updateKatalog(event.id, event.data);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });
    on<DeleteKatalog>((event, emit) async{
      emit(KatalogLoading());
      try {
        await repository.deleteKatalog(event.id);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });
  }
}
