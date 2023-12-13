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
      final result = await productDataSource.getAllProduct();
      result.fold((error) => emit(ProductsError(message: error)),
          (data) => emit(ProductsLoaded(model: data)));
    });
  }
}
