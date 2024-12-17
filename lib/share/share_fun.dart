import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';

Future<User> get_User() async {
  User user;
  Repository<String, User> _user_repo;
  _user_repo = await Repository<String, User>(name: 'user_box');
  await _user_repo.init();
  user = await _user_repo.getAt(0);
  return user;
}

User? global_user;
