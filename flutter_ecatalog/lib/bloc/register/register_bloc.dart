import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasource/auth_datasource.dart';
import 'package:flutter_ecatalog/data/model/request/register_request_model.dart';
import 'package:flutter_ecatalog/data/model/response/register_response_model.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDatasource datasource;
  RegisterBloc(this.datasource) : super(RegisterInitial()) {
    on<DoRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      // kirim model register request model ke datasource, menunggu resposne
      final result = await datasource.register(event.model);
      // emit(RegisterLoaded());
      result.fold((error) {
        emit(RegisterError(message: error));
      }, (r) {
        emit(RegisterLoaded(registerResponseModel: r));
      });
    });
  }
}
