import 'bc.dart';

const int INT_MAX = 2147483647;

class UserPrivacy {
  static const noBody = 0x0;
  static const friendOnly = 0x1;
  static const all = 0x10;
  static const canGetInfo = 0x0;
  static const canSeeProfilePicture = 0x1;
  static const canSeeBio = 0x10;
  int perm_CanGetInfo;
  int perm_CanSeePicture;
  int perm_CanSeeBio;
}

class User {
  static const createUser_EmailIsNotValid = 0x1;
  static const createUser_TagIsNotValid = 0x10;
  static const createUser_Success = 0x0;
  static const loginUser_AccountNotFound = 0x1;
  static const loginUser_IncorrectPassword = 0x10;
  static const loginUser_Success = 0x0;
  String name;
  String email;
  String password;
  String profilePictureID;
  String tag;
  int iD = 0;
  UserPrivacy privacy;
  List<int> serialize() {
    List<int> tmp = new List<int>();
    tmp.addAll(BC.uint64ToByte(iD));
    if (privacy != null) {
      tmp.addAll(BC.int32ToByte(privacy.perm_CanGetInfo));
      tmp.addAll(BC.int32ToByte(privacy.perm_CanSeePicture));
      tmp.addAll(BC.int32ToByte(privacy.perm_CanSeeBio));
    } else {
      tmp.addAll(BC.int32ToByte(INT_MAX));
      tmp.addAll(BC.int32ToByte(INT_MAX));
      tmp.addAll(BC.int32ToByte(INT_MAX));
    }
    var emailBytes = email == null ? [0] : BC.stringToByte(email);
    var passBytes = password == null ? [0] : BC.stringToByte(password);
    var nameBytes = name == null ? [0] : BC.stringToByte(name);
    var ppidBytes =
        profilePictureID == null ? [0] : BC.stringToByte(profilePictureID);
    var tagBytes = tag == null ? [0] : BC.stringToByte(tag);
    tmp.addAll(BC.int32ToByte(emailBytes.length));
    tmp.addAll(emailBytes);
    tmp.addAll(BC.int32ToByte(passBytes.length));
    tmp.addAll(passBytes);
    tmp.addAll(BC.int32ToByte(nameBytes.length));
    tmp.addAll(nameBytes);
    tmp.addAll(BC.int32ToByte(ppidBytes.length));
    tmp.addAll(ppidBytes);
    tmp.addAll(BC.int32ToByte(tagBytes.length));
    tmp.addAll(tagBytes);
    return tmp;
  }

  static User Parse(List<int> data) {
    User u = new User();
    int off = 0;
    u.iD = BC.byteToUint64(data, off);
    off += 8;
    int ptmp = BC.byteToInt32(data, off);
    if (ptmp == INT_MAX)
      off += 12;
    else {
      u.privacy = new UserPrivacy();
      u.privacy.perm_CanGetInfo = ptmp;
      off += 4;
      u.privacy.perm_CanSeePicture = BC.byteToInt32(data, off);
      off += 4;
      u.privacy.perm_CanSeeBio = BC.byteToInt32(data, off);
      off += 4;
    }
    //Email
    int len = BC.byteToInt32(data, off);
    off += 4;
    u.email = BC.byteToString(data, off, len);
    off += len;
    //Password
    len = BC.byteToInt32(data, off);
    off += 4;
    u.password = BC.byteToString(data, off, len);
    off += len;
    //Name
    len = BC.byteToInt32(data, off);
    off += 4;
    u.name = BC.byteToString(data, off, len);
    off += len;
    //PP
    len = BC.byteToInt32(data, off);
    off += 4;
    u.profilePictureID = BC.byteToString(data, off, len);
    off += len;
    // TAG
    len = BC.byteToInt32(data, off);
    off += 4;
    u.tag = BC.byteToString(data, off, len);
    off += len;

    return u;
  }

  String toString() {
    String str = "{\r\n\tName: " +
        (name != null ? name : "") +
        "\r\n\tEmail: " +
        (email != null ? email : "") +
        "\r\n\tPassword: " +
        (password != null ? password : "") +
        "\r\n\tTag: " +
        (tag != null ? tag : "") +
        "\r\n\tProfilePictureID: " +
        (profilePictureID != null ? profilePictureID : "") +
        "\r\n\tID: " +
        iD.toString() +
        "\r\n\t" +
        (privacy != null
            ? ("Privacy: \r\n\t{\r\n\t\tPerm_CanGetInfo: " +
                privacy.perm_CanGetInfo.toString() +
                "\r\n\t\tPerm_CanSeePicture: " +
                privacy.perm_CanSeePicture.toString() +
                "\r\n\t\tPerm_CanSeeBio: " +
                privacy.perm_CanSeeBio.toString() +
                "\r\n\t}")
            : "") +
        "\r\n}";
    return str;
  }
}
