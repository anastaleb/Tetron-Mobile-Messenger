import 'dart:typed_data';
import 'dart:convert';

class BC {
  static int byteToInt32(List<int> data, int offset) {
    ByteBuffer ctB =
        new Int8List.fromList(data.sublist(offset, offset + 4)).buffer;
    return ByteData.view(ctB).getInt32(0, Endian.little);
  }

  static String byteToString(List<int> data, int offset, int length) {
    return utf8.decode(data.sublist(offset, offset + length));
  }

  static List<int> stringToByte(String value) {
    return utf8.encode(value);
  }

  static int byteToUint64(List<int> data, int offset) {
    ByteBuffer ctB =
        new Int8List.fromList(data.sublist(offset, offset + 8)).buffer;
    return ByteData.view(ctB).getUint64(0, Endian.little);
  }

  static List<int> uint64ToByte(int value) {
    List<int> tmp = new List<int>();
    tmp.addAll(
        Uint8List(8)..buffer.asByteData().setUint64(0, value, Endian.little));
    return tmp;
  }

  static List<int> int32ToByte(int value) {
    List<int> tmp = new List<int>();
    tmp.addAll(
        Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little));
    return tmp;
  }

  static List<int> dateTimeToByte(DateTime dt) {
    String dts = "0" + dt.day.toString();
    dts += (dt.month < 10 ? "0" + dt.month.toString() : dt.month.toString());
    dts += dt.year.toString();
    dts += (dt.hour < 10 ? "0" + dt.hour.toString() : dt.hour.toString());
    dts += (dt.minute < 10 ? "0" + dt.minute.toString() : dt.minute.toString());
    dts += (dt.second < 10 ? "0" + dt.second.toString() : dt.second.toString());
    List<int> tmp = new List<int>();
    var bts = stringToByte(dts);
    tmp.addAll(int32ToByte(bts.length));
    tmp.addAll(bts);
    return tmp;
  }

  static DateTime byteToDateTime(List<int> data, int offset) {
    String dts = byteToString(data, offset + 4, byteToInt32(data, offset));
    int day = int.parse(dts.substring(0, 2));
    int month = int.parse(dts.substring(2, 4));
    int year = int.parse(dts.substring(4, 8));
    int hour = int.parse(dts.substring(8, 10));
    int min = int.parse(dts.substring(10, 12));
    int sec = int.parse(dts.substring(12, 14));
    return new DateTime(year, month, day, hour, min, sec);
  }
}
