part of 'katalog_bloc.dart';

abstract class KatalogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchKatalog extends KatalogEvent {}

class CreateKatalog extends KatalogEvent {
  final Map<String, dynamic> data;
  CreateKatalog(this.data);
  @override
  List<Object> get props => [data];
}

class UpdateKatalog extends KatalogEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateKatalog(this.id, this.data);
  @override
  List<Object> get props => [id, data];
}

class DeleteKatalog extends KatalogEvent {
  final int id;
  DeleteKatalog(this.id);
  @override
  List<Object> get props => [id];
}