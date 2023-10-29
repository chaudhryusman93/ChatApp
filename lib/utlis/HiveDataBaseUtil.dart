import 'package:chatter/modelClasses/ChatModel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDataBaseUtil {
  static late final BoxCollection boxCollection;
  static late final CollectionBox<Map> box;
  static late String chatRoom;

  static const String chat_database = 'ChatDataBase';

  static const String user_chats_box = 'UserChatsBox';
  static const String chats = 'Chats';

  static Future<void> init() async {
    final appDocDirectory = await getApplicationDocumentsDirectory();

    final boxCollection = await BoxCollection.open(
        HiveDataBaseUtil.chat_database, // Name of your database
        {HiveDataBaseUtil.user_chats_box}, // Names of your boxes
        path: "${appDocDirectory.path}/");
    box = await boxCollection.openBox(HiveDataBaseUtil.user_chats_box);
  }

  static Future<void> addChat(
      UserChatModel userChatModel, String chatRoom) async {
    List<UserChatModel>? userChats = [];
    userChats.add(userChatModel);
    userChats.addAll(await getAllChats(chatRoom));

    List<Map<String, dynamic>> listMap = [];

    userChats.forEach((element) {
      Map<String, dynamic> map = element.toMap();
      listMap.add(map);
    });
    await box.put(chatRoom, {HiveDataBaseUtil.chats: listMap});
  }

  static Future<List<UserChatModel>> getAllChats(String chatRoom) async {
    List<UserChatModel> listChatModel = [];
    Map<dynamic, dynamic>? map =
        await box.get(chatRoom) as Map<dynamic, dynamic>? ?? {};
    if (map.isNotEmpty) {
      List listMap = map[HiveDataBaseUtil.chats];

      listChatModel = listMap.map((e) => UserChatModel.fromMap(e)).toList();
    }
    return listChatModel;
  }
}
