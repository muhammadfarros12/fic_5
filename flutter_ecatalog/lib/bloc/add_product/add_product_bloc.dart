import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasource/product_datasource.dart';
import 'package:flutter_ecatalog/data/model/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/model/response/product_response_model.dart';
import 'package:meta/meta.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductDataSource productDataSource;
  AddProductBloc(
    this.productDataSource,
  ) : super(AddProductInitial()) {
    on<DoAddProductEvent>((event, emit) async{
      emit(AddProductLoading());
      final result = await productDataSource.createProduct(event.model);
      result.fold(
        (error) => emit(AddProductError(message: error)), 
        (data) => emit(AddProductLoaded(model: data))
        );
    });
  }
}
