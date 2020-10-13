import 'bc.dart';

class Message {
  int messageID;
  int replayMessageID;
  int from;
  int to;
  String content;
  DateTime time;
  Message() {
    time = DateTime.now();
  }
  List<int> serialize() {
    List<int> bts = new List<int>();
    bts.addAll(BC.uint64ToByte(messageID));
    bts.addAll(BC.uint64ToByte(replayMessageID));
    bts.addAll(BC.uint64ToByte(from));
    bts.addAll(BC.uint64ToByte(to));
    bts.addAll(BC.dateTimeToByte(time));
    bts.addAll(BC.int32ToByte(content.length));
    var x = BC.stringToByte(content);
    bts.addAll(BC.int32ToByte(x.length));
    bts.addAll(x);
    return bts;
  }

  static Message parse(List<int> data) {
    Message msg = new Message();
    msg.messageID = BC.byteToUint64(data, 0);
    msg.replayMessageID = BC.byteToUint64(data, 8);
    msg.from = BC.byteToUint64(data, 16);
    msg.to = BC.byteToUint64(data, 24);
    int cOff = 32 + 4 + BC.byteToInt32(data, 32);
    msg.time = BC.byteToDateTime(data, 32);
    msg.content = BC.byteToString(data, cOff + 4, BC.byteToInt32(data, cOff));
    return msg;
  }

  String toString() {
    return "{\r\n\tMessageID: " +
        messageID.toString() +
        "\r\n\tReplayMessageID: " +
        replayMessageID.toString() +
        "\r\n\tFrom: " +
        from.toString() +
        "\r\n\tTo: " +
        to.toString() +
        "\r\n\tTime: " +
        time.toString() +
        "\r\n\tContent: " +
        content +
        "\r\n}";
  }
}
