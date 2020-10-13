import 'client.dart';
import 'user.dart';

void main() {
  Client x = new Client("log.txt");
  x.onConnect = (sc) {
    User u = new User();
    u.email = "darttest3@dev.com";
    u.password = "123451p";
    u.tag = "@darttest3";
    print(u);
    x.createUser(u);
  };
  x.onCreateUser = (errCode) {
    print("CreateUser ErrorCode : " + errCode.toString());
    if (errCode == User.createUser_Success) {
    } else if (errCode == User.createUser_EmailIsNotValid) {
      User u = new User();
      u.email = "darttest2@dev.com";
      u.password = "123451p";
      x.loginUser(u);
    }
  };
  x.onLoginResult = (errCode) {
    switch (errCode) {
      case User.loginUser_AccountNotFound:
        print("Login ErrorCode : LoginUser_AccountNotFound");
        break;
      case User.loginUser_Success:
        print("Login ErrorCode : LoginUser_Success");

        x.getUserInfo_Tag("@test123");
        break;
      case User.loginUser_IncorrectPassword:
        print("Login ErrorCode : LoginUser_IncorrectPassword");
        break;
      default:
    }
  };
  x.onUserInfoResult = (usr) {
    print(usr);
  };
  x.onMessageReceive = (msg) {
    print(msg);
  };
  x.connect();
}
