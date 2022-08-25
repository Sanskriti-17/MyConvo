import 'package:messenger/providers/general/chatroom_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../general/user_data_provider.dart';

List<SingleChildWidget> providersCollection = [
  ChangeNotifierProvider(create: (_) => UserDataProvider()),
  ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
];



