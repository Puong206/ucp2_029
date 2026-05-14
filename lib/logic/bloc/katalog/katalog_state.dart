part of 'katalog_bloc.dart';

abstract class KatalogState extends Equatable {
  @override
  List<Object> get props => [];
}

class KatalogInitial extends KatalogState {}

class KatalogLoading extends KatalogState {}

class KatalogLoaded extends KatalogState {
  final List<KatalogModel> katalogList;
  final List<KatalogModel> filteredList;

  KatalogLoaded(this.katalogList, {List<KatalogModel>? filtered})
      : filteredList = filtered ?? katalogList;

  @override
  List<Object> get props => [katalogList, filteredList];
}

class KatalogActionSuccess extends KatalogState {
  final String message;
  KatalogActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class KatalogError extends KatalogState {
  final String message;
  KatalogError(this.message);

  @override
  List<Object> get props => [message];
}

// Alias agar backward-compatible dengan kode lama
class KatalogCreatedSuccess extends KatalogActionSuccess {
  KatalogCreatedSuccess() : super('Berhasil');
}