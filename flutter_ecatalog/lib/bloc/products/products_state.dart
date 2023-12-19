part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final int offset;
  final int limit;
  final bool isNext;
  final List<ProductResponseModel> model;

  ProductsLoaded({
    required this.model,
    this.offset = 0,
    this.limit = 10,
    this.isNext = false,
    });

}

 
final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
