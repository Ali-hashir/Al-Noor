// category_bloc.dart
import 'dart:io';

import 'package:alnoor/models/product.dart';
import 'package:alnoor/repositories/favourites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class FavouritesEvent {}

class LoadFavourites extends FavouritesEvent {
  final String search;

  LoadFavourites({required this.search});
}

class AddFavourites extends FavouritesEvent {
  final String productId;
  final String collectionName;

  AddFavourites({required this.productId, required this.collectionName});
}

class DeleteFavourites extends FavouritesEvent {
  final String id;

  DeleteFavourites({required this.id});
}

class DeleteUpload extends FavouritesEvent {
  final String id;

  DeleteUpload({required this.id});
}

class UploadImage extends FavouritesEvent {
  final File imageFile;
  final String collectionName;

  UploadImage({required this.imageFile, required this.collectionName});
}

// States
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteDeleted extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<List<Product>> favourites;
  FavouriteLoaded(this.favourites);
}

class FavouriteAdded extends FavouriteState {
  final List<List<Product>> favourites;
  FavouriteAdded(this.favourites);
}

class FavouriteError extends FavouriteState {
  final String message;
  FavouriteError(this.message);
}

class UploadImageInitial extends FavouriteState {}

class UploadImageLoading extends FavouriteState {}

class UploadImageSuccess extends FavouriteState {
  UploadImageSuccess();
}

class UploadImageFailure extends FavouriteState {
  final String message;

  UploadImageFailure(this.message);
}

// BLoC
class FavouriteBloc extends Bloc<FavouritesEvent, FavouriteState> {
  final FavouritesRepository repository;

  FavouriteBloc(this.repository) : super(FavouriteInitial()) {
    on<LoadFavourites>(_onLoadFavourites);
    on<AddFavourites>(_onAddFavourites);
    on<UploadImage>(_onUploadImage);
    on<DeleteFavourites>(_onDeleteFavourites);
    on<DeleteUpload>(_onDeleteUpload);
  }

  Future<void> _onLoadFavourites(
      LoadFavourites event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      final favourites = await repository.fetchFavourites(event.search);
      emit(FavouriteLoaded(favourites));
    } catch (e) {
      emit(FavouriteError('Failed to load favourites'));
    }
  }

  Future<void> _onAddFavourites(
      AddFavourites event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      await repository.addFavourites(event.productId, event.collectionName);
      await Future.delayed(Duration(seconds: 2));
      final favourites = await repository.fetchFavourites("");
      emit(FavouriteLoaded(favourites));
    } catch (e) {
      emit(FavouriteError('Failed to add product to favourites'));
    }
  }

  Future<void> _onUploadImage(
      UploadImage event, Emitter<FavouriteState> emit) async {
    emit(UploadImageLoading());
    emit(FavouriteLoading());
    try {
      await repository.uploadImage(event.imageFile, event.collectionName);
      await Future.delayed(Duration(seconds: 2));
      final favourites = await repository.fetchFavourites("");
      emit(FavouriteLoaded(favourites));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onDeleteFavourites(
      DeleteFavourites event, Emitter<FavouriteState> emit) async {
    try {
      await repository.deleteFavourites(event.id);
      // final favourites = await repository.fetchFavourites("");
      // emit(FavouriteLoaded(favourites));
    } catch (e) {
      emit(FavouriteError('Failed to delete favourite'));
    }
  }

  Future<void> _onDeleteUpload(
      DeleteUpload event, Emitter<FavouriteState> emit) async {
    try {
      await repository.deleteUpload(event.id);
      // final favourites = await repository.fetchFavourites("");
      // emit(FavouriteLoaded(favourites));
    } catch (e) {
      emit(FavouriteError('Failed to delete upload'));
    }
  }
}
