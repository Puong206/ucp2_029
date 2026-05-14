import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/data/repositories/katalog_repository.dart';

part 'katalog_event.dart';
part 'katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final KatalogRepository repository;

  List<KatalogModel> _allKatalog = [];

  KatalogBloc({required this.repository}) : super(KatalogInitial()) {
    on<FetchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final list = await repository.getAllKatalog();
        _allKatalog = list;
        emit(KatalogLoaded(list));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<SearchKatalog>((event, emit) {
      final query = event.query.toLowerCase().trim();
      if (query.isEmpty) {
        emit(KatalogLoaded(_allKatalog));
      } else {
        final filtered = _allKatalog.where((k) {
          return k.brand.toLowerCase().contains(query) ||
              k.model.toLowerCase().contains(query) ||
              k.transmisi.toLowerCase().contains(query) ||
              k.status.toLowerCase().contains(query) ||
              (k.namaKategori?.toLowerCase().contains(query) ?? false);
        }).toList();
        emit(KatalogLoaded(_allKatalog, filtered: filtered));
      }
    });

    on<CreateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.createKatalog(event.data, imagePath: event.imagePath);
        emit(KatalogActionSuccess('Katalog berhasil ditambahkan'));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<UpdateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.updateKatalog(event.id, event.data,
            imagePath: event.imagePath);
        emit(KatalogActionSuccess('Katalog berhasil diperbarui'));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<DeleteKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.deleteKatalog(event.id);
        emit(KatalogActionSuccess('Katalog berhasil dihapus'));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });
  }
}
