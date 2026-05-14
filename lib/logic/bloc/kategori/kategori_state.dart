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
  const KategoriLoaded(this.kategoriList);

  @override
  List<Object> get props => [kategoriList];
}

class KategoriActionSuccess extends KategoriState {
  final String message;
  const KategoriActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class KategoriError extends KategoriState {
  final String message;
  const KategoriError(this.message);

  @override
  List<Object> get props => [message];
}

// Alias backward-compat
class KategoriCreatedSuccess extends KategoriActionSuccess {
  const KategoriCreatedSuccess() : super('Berhasil');
}