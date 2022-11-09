import 'package:flutter/material.dart';
import 'package:friendview/models/user_model.dart';
import 'package:friendview/repositories/add_friend_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddFriendState with ChangeNotifier {
  AddFriendState({required this.context}){
    initData();
  }

  ///////////////////////////////////////////////////////////////

  BuildContext context;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>(debugLabel: "AddFriendView");
  final animetedKey = GlobalKey<AnimatedListState>();
  AddFriendRepository _addFriendRep = AddFriendRepository();
  int _lastIndex = 0;
  int _index = 0;
  List<UserModel> _user = [];
  List<String> _hobby = ["Run", "Reading", "Pending", "Sing"];
  List<UserModel> _userTemp = [
    UserModel(
      name: "syah",
      age: 20,
      location: 6,
      description: "Alicia got up. From now on, the Elf Race will become a subordinate race of the Human Race. We will follow the lead of the Human Race ",
      image: "https://lh3.googleusercontent.com/kqJHQAE-KB8OHu0Nf9lbpq0xaDEm1c-KcxH3bZ2qSXsjkHCiF8sBCvpir_NlGk1zq49YB1mW9-0q2ueFjfD92-jSabd-E0dOTWI=s1066",
    ),
    UserModel(
      name: "Sarah",
      age: 23,
      location: 1,
      description: "Elder Nangong smiled. After these few days of negotiations, the Elf Race, Golden Spear Race, and… will become a subordinate race of the Human Race. From now on, they will follow the Human Race, and the Human Race will provide protection for them, ensuring their development.",
      image: "https://thumb.suara.com/reZoVUpvtsarJPuHzNLDskoNKUQ=/653x366/https://media.suara.com/pictures/653x366/2022/02/10/73905-ilustrasi-gadis-tersenyum.jpg",
    ),
  ];

  get scaffoldState => _scaffoldState;
  bool get isLoading => _isLoading;
  List<UserModel> get user => _user;
  List<String> get hobby => _hobby;
  int get lastIndex => _lastIndex;
  int get index => _index;

  //////////////////////////////////////////////////////////////
  initData() async {
    bool isEmpty= await _addFriendRep.isUserEmpty();
    print(isEmpty);
    if(isEmpty){
      Future.forEach(_userTemp, (element) async => await _addFriendRep.addUser(element)).
      then((value) async => await _addFriendRep.getNewFriends().then((value) {
        _user = value;
        _isLoading = false;
        notifyListeners();
      }));
    } else {
      await _addFriendRep.getNewFriends().then((value) {
        _user = value;
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> backUser() async {
    var user = await _addFriendRep.getLastFriend();
    _user.insert(lastIndex, user);
    animetedKey.currentState!.insertItem(lastIndex);
    notifyListeners();
  }

  changeList(int index) async {
    _lastIndex = index;
    await _addFriendRep.addNewFriends(_user[index].id!);
    _user.removeAt(index);
    notifyListeners();
  }
  changeIndex(int index) async {
    _index = index;
    notifyListeners();
  }
}
