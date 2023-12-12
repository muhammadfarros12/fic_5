part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterLoaded extends RegisterState {
  final RegisterResponseModel registerResponseModel;

  RegisterLoaded({required this.registerResponseModel});


}
 
final class RegisterError extends RegisterState {
  final String message;

  RegisterError({required this.message});
}
