part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductResponseModel> model;

  ProductsLoaded({required this.model});

}

 
final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
