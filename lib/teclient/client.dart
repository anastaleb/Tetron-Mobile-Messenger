import 'dart:async';
import 'dart:collection';
import 'Command.dart';
import 'message.dart';
import 'user.dart';
import 'dart:io';
import 'bc.dart';
import 'dart:core';

class Client {
  //Callbacks
  Function(SecureSocket) onConnect;
  Function(int errCode) onCreateUser;
  Function(int errCode) onLoginResult;
  Function(User user) onUserInfoResult;
  Function(Message message) onMessageReceive;

  User get currentUser => usr;
  User usr;
  SecureSocket sc;
  bool connected = false;
  int connectTryCount = 0;
  int connectMaxTrys = 3;
  int delayPerTry = 3000;
  int connectLoopDelay = 10000;
  Timer logTimer;
  File log;
  Queue<String> logLines;
  Client(String logfn) {
    log = new File(logfn);
    log.delete();
    log.create();
    logLines = new Queue<String>();
    logTimer = new Timer(new Duration(milliseconds: 50), flushLog);
  }
  void logToFile(String line) {
    String dtLine = "[" + DateTime.now().toString() + "] " + line + "\r\n";
    logLines.add(dtLine);
  }

  void flushLog() {
    if (logLines.length > 0) {
      log.writeAsString(logLines.removeFirst(),
          flush: true, mode: FileMode.append);
    }
    logTimer = new Timer(new Duration(milliseconds: 50), flushLog);
  }

  void createUser(User usr) {
    if (usr.tag[0] != '@') usr.tag = "@" + usr.tag;
    logToFile("Sending CreateUser Request to server with " + usr.toString());
    this.usr = usr;
    if (sc != null) {
      sc.add(new Command(Command.createUser, usr.serialize()).serialize());
    }
  }

  void loginUser(User info) {
    logToFile("Sending LoginUser Request to server with " + usr.toString());
    if (sc != null) {
      sc.add(new Command(Command.loginUser, info.serialize()).serialize());
    }
  }

  void sendMessage(Message msg) {
    if (sc != null) {
      sc.add(new Command(Command.message, msg.serialize()).serialize());
    }
  }

  void getUserInfo_Tag(String tag) {
    logToFile("Sending GetUserInfo_Tag Request to server with " + tag);
    if (sc != null) {
      List<int> tmp = new List<int>();
      tmp.addAll(BC.int32ToByte(Command.getUserInfo_TagFlag));
      tmp.addAll(BC.stringToByte(tag));
      sc.add(new Command(Command.getUserInfo, tmp).serialize());
    }
  }

  void getUserInfo_ID(int id) {
    logToFile("Sending GetUserInfo_ID Request to server with " + id.toString());
    if (sc != null) {
      List<int> tmp = new List<int>();
      tmp.addAll(BC.int32ToByte(Command.getUserInfo_IDFlag));
      tmp.addAll(BC.uint64ToByte(id));
      sc.add(new Command(Command.getUserInfo, tmp).serialize());
    }
  }

  void connect() async {
    logToFile("connect called !");
    if (connected) return;
    await Socket.connect("46.53.57.252", 5555)
        .then(socketThen)
        .catchError(socketError);
    print("End");
  }

  void socketError(e) async {
    logToFile("ERROR::Socket::" + e.toString());
    print(e);
    connectTryCount++;
    if (connectTryCount == connectMaxTrys) {
      print("Connection Failed After " + connectMaxTrys.toString() + " Trys !");
      print("Waiting " +
          (connectLoopDelay / 1000).toString() +
          "s Before Retry..");
      await Future.delayed(Duration(milliseconds: connectLoopDelay));
      connectTryCount = 0;
      logToFile("Calling connect from socketError");
      connect();
      return;
    }
    await Future.delayed(Duration(milliseconds: delayPerTry));
    logToFile("Calling connect from socketError");
    connect();
  }

  void socketThen(Socket s) async {
    s.setOption(SocketOption.tcpNoDelay, true);
    s.handleError((err, StackTrace st) {
      logToFile("Socket::handleError:");
      logToFile(err.toString());
      logToFile(st.toString());
    });
    print("Socket::Connected !");
    logToFile("Socket::Connected !");
    logToFile("Socket::Calling SecureSocket.secure...");
    sc = await SecureSocket.secure(s, onBadCertificate: (cert) {
      return true;
    }, supportedProtocols: ["TLS1.2"]).catchError((e) {
      print(e);
      logToFile("ERROR::SecureSocket::" + e.toString());
      sc.close();
      return;
    }).then((sec) {
      logToFile("SecureSocket::Connected !");
      sec.handleError((err, StackTrace st) {
        logToFile("SecureSocket::handleError:");
        logToFile(err.toString());
        logToFile(st.toString());
      });
      return sec;
    });
    connected = true;
    if (onConnect != null) onConnect(sc);
    sc.listen(socketListen, onDone: doneHandler);
  }

  void doneHandler() {
    connected = false;
    logToFile("Socket::Stream::doneHandler::Disconnected !");
    sc.destroy();
    logToFile("Calling connect from doneHandler");
    connect();
  }

  void socketListen(List<int> b) {
    try {
      Command cmd = Command.parse(b);
      logToFile(cmd.toString());
      switch (cmd.commandType) {
        case Command.ping:
          Command tmp = new Command(Command.ping, [0]);
          sc.add(tmp.serialize());
          sc.flush();
          break;
        case Command.createUser:
          int ec = BC.byteToInt32(cmd.data, 0);
          if (ec == User.createUser_Success) {
            logToFile("CreateUser => CreateUser_Success");
            List<int> tmp = new List<int>();
            tmp.addAll(BC.int32ToByte(Command.getUserInfo_TagFlag));
            tmp.addAll(BC.stringToByte(usr.tag));
            sc.add(new Command(Command.getUserInfo, tmp).serialize());
            sc.flush();
          } else if (ec == User.createUser_EmailIsNotValid)
            logToFile("CreateUser => CreateUser_EmailIsNotValid");
          else if (ec == User.createUser_TagIsNotValid)
            logToFile("CreateUser => CreateUser_TagIsNotValid");
          if (onCreateUser != null) onCreateUser(ec);
          break;
        case Command.getUserInfo:
          User u = User.Parse(cmd.data);
          logToFile(u.toString());
          if (u.tag == usr.tag) usr = u;
          if (onUserInfoResult != null) onUserInfoResult(u);
          break;
        case Command.loginUser:
          int errCode = BC.byteToInt32(cmd.data, 0);
          logToFile("LoginUser ErrorCode = " + errCode.toString());
          if (errCode == User.loginUser_Success) {
            User u = User.Parse(cmd.data.sublist(4));
            usr = u;
          }
          if (onLoginResult != null) onLoginResult(errCode);
          break;
        case Command.message:
          Message msg = Message.parse(cmd.data);
          if (onMessageReceive != null) onMessageReceive(msg);
          break;
      }
    } catch (e) {
      logToFile(e.toString());
      print(e);
    }
  }
}
