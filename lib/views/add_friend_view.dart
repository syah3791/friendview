import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendview/providers/add_friend_state.dart';
import 'package:friendview/widgets/v_responsive_layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AddFriendView extends StatefulWidget {
  AddFriendView({Key? key})
      : super(key: key);

  _AddFriendViewState createState() => _AddFriendViewState();
}

class _AddFriendViewState extends State<AddFriendView> {
  AddFriendState? state;
  Size? _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddFriendState(context: context)),
      ],
      child: Consumer(
        builder: (BuildContext context, AddFriendState state, Widget? child) {
          this.state = state;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings_backup_restore, color: Colors.white, size: 32),
                    onPressed: () => state!.backUser(),
                  ),
                ],
              ),
            ),
            body: _mainBody(),
          );
        },
      ),
    );
  }

  _mainBody() =>
      VResponsiveLayout(
        mobile: _listFriends(),
        tablet: Row(
          children: [
            Expanded(
              flex: 8,
              child: _listFriends(),
            ),
            Expanded(
              flex: 5,
              child: _detailUsers(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size!.width > 1340 ? 8 : 10,
              child: _listFriends(),
            ),
            Expanded(
              flex: _size!.width > 1340 ? 4 : 6,
              child: _detailUsers(),
            ),
          ],
        ),
      );

  Widget _listFriends() =>
      state!.isLoading ? CircularProgressIndicator() : AnimatedList(
        shrinkWrap: true,
        key: state!.animetedKey,
        initialItemCount: state!.user.length,
        itemBuilder: (context, index, animation) =>
            ScaleTransition(
              scale: animation,
              child: cardFriend(index),
            ),
      );

  Widget _detailUsers() =>
      state!.user.length > 0 ? cardFriend(state!.index) : Container();

  void addFriend(int index) {
    state!.animetedKey.currentState!.removeItem(
      index, (context, animation) => SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).animate(animation),
            child: cardFriend(index),
          ),
    );
    Future.delayed(Duration(seconds: 1)).then((value) => state!.changeList(index));
  }
  
  Widget cardFriend(int index) =>
      InkWell(
        child: Card(
          margin: EdgeInsets.all(8),
          child: Container(
            height: _size!.height/1.23,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      fit: BoxFit.cover,
                      state!.user[index].image ?? '',
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(18),
                      height: _size!.height/2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.black12,
                            width: 1.0
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  '${state!.user[index].name}, ${state!.user[index].age}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.gps_fixed, color: Colors.black26, size: 25,),
                                  SizedBox(width: 8,),
                                  Text(
                                    '${state!.user[index].location}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black26,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 8,),
                          Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: state!.hobby.map<Widget>((item){
                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent.withOpacity(1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  );
                                },).toList(),
                              )
                          ),
                          Flexible(
                            child: Text(
                              '${state!.user[index].description}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 32),
                      onPressed: () => addFriend(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
