part of 'kategori_bloc.dart';

abstract class KategoriState extends Equatable {
  const KategoriState();
  
  @override
  List<Object> get props => [];
}

class KategoriInitial extends KategoriState {}

class KategoriLoading extends KategoriState {}

class KategoriLoaded extends KategoriState {
  final List<KategoriModel> kategoriList;
  KategoriLoaded(this.kategoriList);

  @override
  List<Object> get props => [kategoriList];
}

class KategoriError extends KategoriState {
  final String message;
  KategoriError(this.message);
  
  @override
  List<Object> get props => [message];
}

class KategoriCreatedSuccess extends KategoriState {}