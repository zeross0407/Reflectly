import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:myrefectly/core/error/failures.dart';
import 'package:myrefectly/features/auth/domain/entities/user_entity.dart';
import 'package:myrefectly/features/auth/domain/usecases/login_usecase.dart';
import 'package:myrefectly/main.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final LoginUseCase loginUseCase;

  _LoginStore({required this.loginUseCase});

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  UserEntity? user;

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;

    final Either<Failure, UserEntity> result = await loginUseCase(LoginParams(
      email: email,
      password: password,
    ));

    return result.fold(
      (failure) {
        isLoading = false;
        if (failure is ValidationFailure) {
          errorMessage = failure.message;
          return false;
        } else if (failure is AuthFailure) {
          errorMessage = 'Invalid email or password';
          return false;
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
          return false;
        }
      },
      (user) {
        this.user = user;
        isLoading = false;

        // Update global tokens
        refresh_token = user.refreshToken;
        access_token = user.accessToken;

        return true;
      },
    );
  }

  @action
  void reset() {
    email = '';
    password = '';
    errorMessage = null;
    isLoading = false;
  }
}
