
import 'package:friendview/models/user_model.dart';
import 'package:friendview/utils/v_database.dart';

class AddFriendRepository {
  addUser(UserModel user) async {
    int id = await DBProvider.db.newUserModel(user);
    return id;
  }

  isUserEmpty() async {
    bool isEmpty = await DBProvider.db.getUserEmpty();
    return isEmpty;
  }

  Future getNewFriends() async {
    List<UserModel> data = await DBProvider.db.getNewFriends();
    return data;
  }

  addNewFriends(int id) async {
    var data = await DBProvider.db.newPersonal(id);
    print(data);
    return data;
  }

  getLastFriend() async {
    UserModel data = await DBProvider.db.getLastFriend();
    return data;
  }
}
