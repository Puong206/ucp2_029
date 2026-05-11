part of 'kategori_bloc.dart';

abstract class KategoriEvent extends Equatable {
  const KategoriEvent();

  @override
  List<Object> get props => [];
}

class FetchKategori extends KategoriEvent {}

class CreateKategori extends KategoriEvent {
  final Map<String, dynamic> data;
  const CreateKategori({required this.data});
  
  @override
  List<Object> get props => [data];
}

class UpdateKategori extends KategoriEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateKategori({required this.id, required this.data});
  
  @override
  List<Object> get props => [id, data];
}

class DeleteKategori extends KategoriEvent {
  final int id;
  const DeleteKategori({required this.id});
  
  @override
  List<Object> get props => [id];
}