part of 'katalog_bloc.dart';

abstract class KatalogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchKatalog extends KatalogEvent {}

class SearchKatalog extends KatalogEvent {
  final String query;
  SearchKatalog({required this.query});
  @override
  List<Object> get props => [query];
}

class CreateKatalog extends KatalogEvent {
  final Map<String, dynamic> data;
  final String? imagePath; // path file gambar dari galeri (nullable)
  CreateKatalog({required this.data, this.imagePath});
  @override
  List<Object> get props => [data];
}

class UpdateKatalog extends KatalogEvent {
  final int id;
  final Map<String, dynamic> data;
  final String? imagePath; // path file gambar dari galeri (nullable)
  UpdateKatalog({required this.id, required this.data, this.imagePath});
  @override
  List<Object> get props => [id, data];
}

class DeleteKatalog extends KatalogEvent {
  final int id;
  DeleteKatalog({required this.id});
  @override
  List<Object> get props => [id];
}