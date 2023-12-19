import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasource/product_datasource.dart';
import 'package:flutter_ecatalog/data/model/response/product_response_model.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource productDataSource;
  ProductsBloc(
    this.productDataSource,
  ) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoading());
      final result =
          await productDataSource.getPaginationProduct(offset: 0, limit: 10);
      result.fold((error) => emit(ProductsError(message: error)), (data) {
        bool isNext = data.length == 10;
        emit(ProductsLoaded(model: data, isNext: isNext));
      });
    });
    on<GetNextProductsEvent>((event, emit) async {
      final currentState = state as ProductsLoaded;
      final result = await productDataSource.getPaginationProduct(
          offset: currentState.offset + 10, limit: 10);
      result.fold(
          (error) => emit(
                ProductsError(message: error),
              ), (result) {
        bool isNext = result.length == 10;
        emit(ProductsLoaded(
            model: [...currentState.model, ...result],
            offset: currentState.offset + 10,
            limit: 10,
            isNext: isNext));
      });
    });
  }
}
