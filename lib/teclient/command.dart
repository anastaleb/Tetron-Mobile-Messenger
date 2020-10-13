import 'bc.dart';

class Command {
  static const int ping = 0x1;
  static const int getVersion = 0x10;
  static const int createUser = 0x11;
  static const int loginUser = 0x110;
  static const int getUserInfo = 0x111;
  static const int changeUserPrivacy = 0x1110;
  static const int message = 0x1111;
  static const int searchUser = 0x11110;
  static const int fileRequest = 0x11111;
  //GetUserInfo Flags:
  static const int getUserInfo_TagFlag = 0x1;
  static const int getUserInfo_IDFlag = 0x0;

  int commandType;
  List<int> data;
  Command(int ct, List<int> data) {
    commandType = ct;
    this.data = data;
  }
  List<int> serialize() {
    List<int> tmp = new List<int>();
    tmp.addAll(BC.int32ToByte(commandType));
    tmp.addAll(BC.int32ToByte(data.length));
    tmp.addAll(data);
    return tmp;
  }

  static Command parse(List<int> data) {
    int ct = BC.byteToInt32(data, 0);
    int len = BC.byteToInt32(data, 4);
    return new Command(ct, data.sublist(8, 8 + len));
  }

  String toString() {
    String cts = "";
    switch (commandType) {
      case ping:
        cts = "Ping";
        break;
      case createUser:
        cts = "CreateUser";
        break;
      case loginUser:
        cts = "LoginUser";
        break;
      case getUserInfo:
        cts = "GetUserInfo";
        break;
      case changeUserPrivacy:
        cts = "ChangeUserPrivacy";
        break;
      case message:
        cts = "Message";
        break;
    }
    return "{\r\n\tCommandType: " +
        cts +
        "\r\n\tData: " +
        data.toString() +
        "\r\n}";
  }
}
