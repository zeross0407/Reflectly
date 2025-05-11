import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class AuthFailure extends Failure {
  final int code;
  
  const AuthFailure({required String message, required this.code}) 
      : super(message: message);
  
  @override
  List<Object> get props => [message, code];
}

class ValidationFailure extends Failure {
  final String field;
  
  const ValidationFailure({required String message, required this.field}) 
      : super(message: message);
  
  @override
  List<Object> get props => [message, field];
} 