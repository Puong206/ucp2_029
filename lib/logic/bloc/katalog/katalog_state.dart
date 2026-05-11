part of 'katalog_bloc.dart';

sealed class KatalogState extends Equatable {
  const KatalogState();
  
  @override
  List<Object> get props => [];
}

final class KatalogInitial extends KatalogState {}
