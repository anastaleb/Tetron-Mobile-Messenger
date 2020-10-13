import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:core';
import 'package:Tetron/models/model.dart';

class SqlHelper {
  static Database Tetron;

  static Future<Database> get openDB async {
    if (Tetron != null) return Tetron;
    return await intiDB();
  }

  static Future<Database> intiDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'Tetron.db'),
        onCreate: (db, version) async {
      await db.execute(Command.createDBCommand);
    }, version: 1);
  }
}

class UserOperations {
  static void createUser(int userID, String NickName, String email,
      String password, String bio, String status, DateTime lastSeen) async {
    final db = await SqlHelper.openDB;

    db.execute('''
    insert into users(userID,NickName,email,password,bio,status,lastSeen)
    values(?,?,?,?,?,?)
    ''', [userID, NickName, email, password, bio, status, lastSeen]);
  }

  static Future<String> getUserNickname(int userID) async {
    final db = await SqlHelper.openDB;

    final receivedData = await db
        .rawQuery('Select NickName from users where userID = ?', [userID]);

    return receivedData[0][0].NickName.toString();
  }

  static Future<String> getUserStatus(int userID) async {
    final db = await SqlHelper.openDB;

    var receivedData = await db.rawQuery('''
    select Status 
    from users 
    where userID = ?
    ''', [userID]);
    return receivedData[0][0].Status.toString();
  }

  static Future<String> getUserBio(int userID) async {
    final db = await SqlHelper.openDB;

    var receivedData = await db.rawQuery('''
    select Bio 
    from users 
    where userID = ?
    ''', [userID]);
    return receivedData[0][0].Bio.toString();
  }

  static Future<DateTime> getUserLastSeen(int userID) async {
    final db = await SqlHelper.openDB;

    var receivedData = await db.rawQuery('''
    select LastSeen 
    from users 
    where userID = ?
    ''', [userID]);
    return DateTime.parse(receivedData[0][0].LastSeen.toString());
  }

  static Future<List<Map<String, dynamic>>> getUserContacts(int userID) async {
    final db = await SqlHelper.openDB;

    return await db.rawQuery('''
    select UserID, NickName, LastSeen, Status, Path as PicturePath
    from users u
    full outer join media m on m.MediaID = u.ProfilePicture
    where userID = (select contactID from contacts where userID = ?)
    ''', [userID]);
  }

  static Future<List<Map<String, dynamic>>> getUserBlockList(int userID) async {
    final db = await SqlHelper.openDB;

    return await db.rawQuery('''
    select UserID, NickName
    from users u
    where userID = (select blockedID from blockedUsers where blockerID = ?)
    ''', [userID]);
  }

  static void insertUser(
      int userID, String nickname, String password, String email) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    insert into users(userID,nickname,password,email)
    values(?,?,?,?)
    ''', [userID, nickname, password, email]);
  }

  static void editUserPhoto(int userID, Media mediaInfo) async {
    MediaOperations.insertMedia(
        mediaInfo.MediaID, mediaInfo.Path, mediaInfo.MediaName);

    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set ProfilePicture = ?
    where userID = ?
    ''', [mediaInfo.MediaID, userID]);
  }

  static void editUserBio(int userID, String bio) async {
    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set bio = ?
    where userID = ?
    ''', [bio, userID]);
  }

  static void editUserPassword(int userID, String password) async {
    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set password = ?
    where userID = ?
    ''', [password, userID]);
  }

  static void editUserNickname(int userID, String nickname) async {
    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set nickname = ?
    where userID = ?
    ''', [nickname, userID]);
  }

  static void editUserFullname(int userID, String newName) async {
    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set fullname = ?
    where userID = ?
    ''', [newName, userID]);
  }

  static void editUserStatus(int userID, UserStatus status) async {
    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set status = ?
    where userID = ?
    ''', [status.toString(), userID]);
  }

  static void editLastSeen(int userID, DateTime lastSeen) async {
    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update Users
    set lastSeen = ?
    where userID = ?
    ''', [lastSeen, userID]);
  }

  static void addNewFriend(int userID, int friendID) async {
    final db = await SqlHelper.openDB;
    db.rawInsert('''
    insert into contacts(userID,contactID)
    values(?,?)
    ''', [userID, friendID]);
  }

  static void removeFriend(int friendID) async {
    final db = await SqlHelper.openDB;
    db.rawDelete('''
    delete from contacts 
    where contactID = ?
    ''', [friendID]);
  }

  static void blockUser(int userID, int friendID) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    insert into blockedUsers(BlockerID,BlockedID)
    values(?,?)
    ''', [userID, friendID]);

    db.rawInsert('''
    insert into blockedUsers(BlockerID,BlockedID)
    values(?,?)
    ''', [friendID, userID]);
  }

  static void unBlockUser(int userID, int friendID) async {
    final db = await SqlHelper.openDB;

    db.rawDelete('''
    delete from blockedUsers
    where (blockerID = ? And blockedID = ?)
    or (blockerID = ? And blockedID)

    ''', [userID, friendID, friendID, userID]);
  }
}

///u will need to get Media ID from the Server
///i think command name was [GEFI].
class MediaOperations {
  static void insertMedia(int mediaID, String mediaPath,
      [String mediaName]) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    Insert into Media(MediaID,MediaName,Path)
    Values(?,?,?)
    ''', [mediaID, mediaName, mediaPath]);
  }

  static Future<Media> getMediaInfo(int mediaID) async {
    final db = await SqlHelper.openDB;
    var _mediaInfo = await db.rawQuery(
        'select MediaID,MediaName,Path from media where mediaID = ?',
        [mediaID]);
    final mediaInfo = _mediaInfo[0][0];

    if (mediaInfo == null) return null;
    return mediaInfo as Media;
  }

  static Future<bool> exists(int mediaID) async {
    final db = await SqlHelper.openDB;
    var _mediaInfo = await db.rawQuery(
        'select MediaID,MediaName,Path from media where mediaID = ?',
        [mediaID]);
    final mediaInfo = _mediaInfo[0][0];

    if (mediaInfo == null) return false;
    return true;
  }
}

class GroupOperations {
  static void createConversation(int groupID, int userID, int friendID) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    insert into groups(groupID,owner,groupName,groupType,createTime)
    values(?,?,?,?,?)
    ''', [
      groupID,
      userID,
      UserOperations.getUserNickname(friendID),
      GroupType.Conversation.toString().toUpperCase(),
      DateTime.now()
    ]);

    addNewMember(groupID, userID, 1);
    addNewMember(groupID, friendID, null);
  }

  static void createGroup(int groupID, int ownerID, List<int> participants,
      [String groupName]) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    insert into groups(groupID,owner,groupName,groupType,createTime)
    values(?,?,?,?,?)
    ''', [
      groupID,
      ownerID,
      groupName,
      GroupType.Group.toString().toUpperCase(),
      DateTime.now()
    ]);

    participants.forEach((user) {
      addNewMember(groupID, user, null);
    });
  }

  static void addNewMember(int groupID, int userID, int adminID) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    insert into participants(groupId,userId,adminId)
    values(?,?,?)
    ''', [groupID, userID, adminID]);
  }

  static void removeMember(int groupID, int userID) async {
    final db = await SqlHelper.openDB;

    db.rawDelete('''
    delete from Participants
    where groupID = ?
    and userID = ?
    ''', [groupID, userID]);
  }

  ///u can use this method to delete group, channel or even conversation
  static void deleteGroup(int groupID) async {
    final db = await SqlHelper.openDB;

    db.rawDelete('''
       delete from groups
       where groupID = ?
       ''', [groupID]);
  }

  static void editGroupDescription(int groupID, String description) async {
    final db = await SqlHelper.openDB;

    db.rawUpdate("""
    update groups
    set description = ?
    where groupID = ?
    and groupType = 'GROUP'
    """, [description, groupID]);
  }

  static void editGroupPicture(int groupID, Media mediaInfo) async {
    MediaOperations.insertMedia(
        mediaInfo.MediaID, mediaInfo.Path, mediaInfo.MediaName);

    final db = await SqlHelper.openDB;
    db.rawUpdate('''
    update groups
    set groupPicture = ?
    where groupID = ?
    ''', [mediaInfo.MediaID, groupID]);
  }

  //hmmmmmm how we use join in this language?!
  static Future<List> getMyGroups(int userID) async {
    final db = await SqlHelper.openDB;

    var receivedData = await db.rawQuery('''    
    select p.groupID, groupName, groupType, createTime
    from Participants p
    full outer join Groups g on g.GroupID = p.GroupID
    full outer join users u on u.userID = p.userID
    where u.userID = ?
    ''', [userID]);

    if (receivedData.length == 0) return null;
    return receivedData;
  }

  static Future<List> getGroupMembers(int groupID) async {
    final db = await SqlHelper.openDB;

    var receivedData = await db.rawQuery('''
    select p.userID, nickname, status, lastSeen
    from participants p
    full outer join users u on u.userID = p.userID
    where p.groupID = ?
    ''', [groupID]);

    if (receivedData.length == 0) return null;
    return receivedData;
  }
}

class MessageOperations {
  static void sendMessage(
      int groupID, int senderID, Message messageInfo) async {
    final db = await SqlHelper.openDB;

    db.rawInsert('''
    insert into messages(messageID, SentTime, Content, Attachment, ReplayMessageID)
    values(?,?,?,?)
    ''', [
      messageInfo.MessageID,
      messageInfo.SentTime,
      messageInfo.Content,
      messageInfo.Attachment,
      messageInfo.MessageToReply
    ]);

    db.rawInsert('''
    insert into groupMessages(groupID, senderID, MessageID)
    values(?,?,?)
    ''', [groupID, senderID, messageInfo.MessageID]);
  }

  static void deleteMessage(int messageID) async {
    final db = await SqlHelper.openDB;

    db.rawDelete('''
    delete from Messages
    where messageID = ?
    ''', [messageID]);

    db.rawDelete('''
    delete from groupMessages
    where messageID = ?
    ''', [messageID]);
  }

  ///@param date represent the start date for getting old messages
  static Future<List<Map<String, dynamic>>> getMoreMessages(
      int groupID, DateTime date) async {
    final db = await SqlHelper.openDB;

    return db.rawQuery('''
    select groupID, senderID, NickName,  messageID, content, path, SentTime
    from groupMessages
    full outer join messages on messages.messageID = groupMessages.messageID
    full outer join users on users.userId = groupMessages.senderID
    where groupID = ?
    and SentTime = ?
    ''', [groupID, date]);
  }
}

class Command {
  static const createDBCommand = '''
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: AdminPermissions
CREATE TABLE AdminPermissions (
    Id integer primary key AUTOINCREMENT
    AdminID      INTEGER,
    PermissionID INTEGER,
    FOREIGN KEY (
        AdminID
    )
    REFERENCES Admins (AdminID),
    FOREIGN KEY (
        PermissionID
    )
    REFERENCES Permissions (PermissionID) 
);


-- Table: Admins
CREATE TABLE Admins (
    AdminID   INTEGER       PRIMARY KEY 
                            NOT NULL,
    AdminType NVARCHAR (50) COLLATE NOCASE
);


-- Table: Contacts
CREATE TABLE Contacts (
    Id integer primary key AUTOINCREMENT,
    ContactID INTEGER NOT NULL,
    UserID    INTEGER,
    FOREIGN KEY (
        ContactID
    )
    REFERENCES Users (UserID),
    FOREIGN KEY (
        UserID
    )
    REFERENCES Users (UserID) 
);


-- Table: GroupMessages
CREATE TABLE GroupMessages (
    Id integer primary key AUTOINCREMENT 
    MessageID INTEGER,
    GroupID   INTEGER,
    SenderID  INTEGER,
    FOREIGN KEY (
        MessageID
    )
    REFERENCES Messages (MessageID),
    FOREIGN KEY (
        GroupID
    )
    REFERENCES Groups (GroupID),
    FOREIGN KEY (
        SenderID
    )
    REFERENCES Users (UserID) 
);


-- Table: Groups
CREATE TABLE Groups (
    GroupID      INTEGER       PRIMARY KEY 
                               NOT NULL,
    GroupName    NVARCHAR (50) NOT NULL
                               COLLATE NOCASE,
    Description  NVARCHAR      COLLATE NOCASE,
    CreateTime   DATETIME,
    GroupPicture INTEGER,
    Owner        INTEGER,
    GroupType    VARCHAR (50)  COLLATE NOCASE,
    FOREIGN KEY (
        GroupPicture
    )
    REFERENCES Media (MediaID),
    FOREIGN KEY (
        Owner
    )
    REFERENCES Users (UserID) 
);


-- Table: Media
CREATE TABLE Media (
    MediaID   INTEGER       PRIMARY KEY 
                            NOT NULL,
    MediaName NVARCHAR (50) COLLATE NOCASE,
    Path      TEXT      COLLATE NOCASE
);

--Table: Blocked Users 
CREATE TABLE BlockedUsers (
    Id integer primary key AUTOINCREMENT,
    BlockerID INTEGER,
    BlockedID INTEGER,
    FOREIGN KEY(BlockerID) REFERENCES users(userID),
    FOREIGN KEY(BlockedID) REFERENCES users(userID)
);

-- Table: Messages
CREATE TABLE Messages (
    MessageID      INTEGER  PRIMARY KEY 
                            NOT NULL,
    SentTime       DATETIME NOT NULL,
    Content        TEXT COLLATE NOCASE,
    Attachment     INTEGER,
    ReplyMessageID INTEGER,
    FOREIGN KEY (
        Attachment
    )
    REFERENCES Media (MediaID),
    FOREIGN KEY (
        ReplyMessageID
    )
    REFERENCES Messages (MessageID) 
);

-- Table: Participants
CREATE TABLE Participants (
    Id integer primary key AUTOINCREMENT,
    UserID  INTEGER,
    GroupID INTEGER,
    AdminID INTEGER,
    FOREIGN KEY (
        UserID
    )
    REFERENCES Users (UserID),
    FOREIGN KEY (
        GroupID
    )
    REFERENCES Groups (GroupID),
    FOREIGN KEY (
        AdminID
    )
    REFERENCES Admins (AdminID) 
);


-- Table: Permissions
CREATE TABLE Permissions (
    
    PermissionID         INTEGER       PRIMARY KEY AUTOINCREMENT
                                       NOT NULL,
    PermissionName       NVARCHAR (50) COLLATE NOCASE,
    PermissionDescrption NVARCHAR      COLLATE NOCASE
);


-- Table: Users
CREATE TABLE Users (
    UserID         INTEGER       PRIMARY KEY
                                 NOT NULL,
    FullName       NVARCHAR (50) NOT NULL
                                 COLLATE NOCASE,
    NickName       NVARCHAR (50) NOT NULL
                                 COLLATE NOCASE,
    Password       NVARCHAR      NOT NULL
                                 COLLATE NOCASE,
    Bio            NVARCHAR (50) COLLATE NOCASE,
    Email          NVARCHAR      NOT NULL
                                 COLLATE NOCASE,
    ProfilePicture INTEGER, 
    LastSeen       DATETIME,
    Status         VARCHAR (10)  NOT NULL
                                 COLLATE NOCASE
                                 DEFAULT 'ONLINE',
    FOREIGN KEY (
        ProfilePicture
    )
    REFERENCES Media (MediaID) 
);


-- Trigger: fkd_AdminPermissions_AdminID_Admins_AdminID
CREATE TRIGGER fkd_AdminPermissions_AdminID_Admins_AdminID
        BEFORE DELETE
            ON Admins
BEGIN
    DELETE FROM AdminPermissions
          WHERE AdminID = OLD.AdminID;
END;


-- Trigger: fkd_AdminPermissions_PermissionID_Permissions_PermissionID
CREATE TRIGGER fkd_AdminPermissions_PermissionID_Permissions_PermissionID
        BEFORE DELETE
            ON Permissions
BEGIN
    DELETE FROM AdminPermissions
          WHERE PermissionID = OLD.PermissionID;
END;


-- Trigger: fkd_Contacts_ContactID_Users_UserID
CREATE TRIGGER fkd_Contacts_ContactID_Users_UserID
        BEFORE DELETE
            ON Users
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Users violates foreign key constraint fkd_Contacts_ContactID_Users_UserID") 
     WHERE (
               SELECT ContactID
                 FROM Contacts
                WHERE ContactID = OLD.UserID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_Contacts_UserID_Users_UserID
CREATE TRIGGER fkd_Contacts_UserID_Users_UserID
        BEFORE DELETE
            ON Users
BEGIN
    DELETE FROM Contacts
          WHERE UserID = OLD.UserID;
END;


-- Trigger: fkd_GroupMessages_GroupID_Groups_GroupID
CREATE TRIGGER fkd_GroupMessages_GroupID_Groups_GroupID
        BEFORE DELETE
            ON Groups
BEGIN
    DELETE FROM GroupMessages
          WHERE GroupID = OLD.GroupID;
END;


-- Trigger: fkd_GroupMessages_MessageID_Messages_MessageID
CREATE TRIGGER fkd_GroupMessages_MessageID_Messages_MessageID
        BEFORE DELETE
            ON Messages
BEGIN
    DELETE FROM GroupMessages
          WHERE MessageID = OLD.MessageID;
END;


-- Trigger: fkd_GroupMessages_SenderID_Users_UserID
CREATE TRIGGER fkd_GroupMessages_SenderID_Users_UserID
        BEFORE DELETE
            ON Users
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Users violates foreign key constraint fkd_GroupMessages_SenderID_Users_UserID") 
     WHERE (
               SELECT SenderID
                 FROM GroupMessages
                WHERE SenderID = OLD.UserID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_Groups_GroupPicture_Media_MediaID
CREATE TRIGGER fkd_Groups_GroupPicture_Media_MediaID
        BEFORE DELETE
            ON Media
BEGIN
    DELETE FROM Groups
          WHERE GroupPicture = OLD.MediaID;
END;


-- Trigger: fkd_Groups_Owner_Users_UserID
CREATE TRIGGER fkd_Groups_Owner_Users_UserID
        BEFORE DELETE
            ON Users
BEGIN
    DELETE FROM Groups
          WHERE Owner = OLD.UserID;
END;


-- Trigger: fkd_Messages_Attachment_Media_MediaID
CREATE TRIGGER fkd_Messages_Attachment_Media_MediaID
        BEFORE DELETE
            ON Media
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Media violates foreign key constraint fkd_Messages_Attachment_Media_MediaID") 
     WHERE (
               SELECT Attachment
                 FROM Messages
                WHERE Attachment = OLD.MediaID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_Messages_ReplyMessageID_Messages_MessageID
CREATE TRIGGER fkd_Messages_ReplyMessageID_Messages_MessageID
        BEFORE DELETE
            ON Messages
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Messages violates foreign key constraint fkd_Messages_ReplyMessageID_Messages_MessageID") 
     WHERE (
               SELECT ReplyMessageID
                 FROM Messages
                WHERE ReplyMessageID = OLD.MessageID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_NotActivatedAccounts_UserID_Users_UserID
CREATE TRIGGER fkd_NotActivatedAccounts_UserID_Users_UserID
        BEFORE DELETE
            ON Users
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Users violates foreign key constraint fkd_NotActivatedAccounts_UserID_Users_UserID") 
     WHERE (
               SELECT UserID
                 FROM NotActivatedAccounts
                WHERE UserID = OLD.UserID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_Participants_AdminID_Admins_AdminID
CREATE TRIGGER fkd_Participants_AdminID_Admins_AdminID
        BEFORE DELETE
            ON Admins
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Admins violates foreign key constraint fkd_Participants_AdminID_Admins_AdminID") 
     WHERE (
               SELECT AdminID
                 FROM Participants
                WHERE AdminID = OLD.AdminID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_Participants_GroupID_Groups_GroupID
CREATE TRIGGER fkd_Participants_GroupID_Groups_GroupID
        BEFORE DELETE
            ON Groups
BEGIN
    DELETE FROM Participants
          WHERE GroupID = OLD.GroupID;
END;


-- Trigger: fkd_Participants_UserID_Users_UserID
CREATE TRIGGER fkd_Participants_UserID_Users_UserID
        BEFORE DELETE
            ON Users
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Users violates foreign key constraint fkd_Participants_UserID_Users_UserID") 
     WHERE (
               SELECT UserID
                 FROM Participants
                WHERE UserID = OLD.UserID
           )
           IS NOT NULL;
END;


-- Trigger: fkd_Users_ProfilePicture_Media_MediaID
CREATE TRIGGER fkd_Users_ProfilePicture_Media_MediaID
        BEFORE DELETE
            ON Media
BEGIN
    SELECT RAISE(ROLLBACK, "delete on table Media violates foreign key constraint fkd_Users_ProfilePicture_Media_MediaID") 
     WHERE (
               SELECT ProfilePicture
                 FROM Users
                WHERE ProfilePicture = OLD.MediaID
           )
           IS NOT NULL;
END;


-- Trigger: fki_AdminPermissions_AdminID_Admins_AdminID
CREATE TRIGGER fki_AdminPermissions_AdminID_Admins_AdminID
        BEFORE INSERT
            ON AdminPermissions
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table AdminPermissions violates foreign key constraint fki_AdminPermissions_AdminID_Admins_AdminID") 
     WHERE NEW.AdminID IS NOT NULL AND 
           (
               SELECT AdminID
                 FROM Admins
                WHERE AdminID = NEW.AdminID
           )
           IS NULL;
END;


-- Trigger: fki_AdminPermissions_PermissionID_Permissions_PermissionID
CREATE TRIGGER fki_AdminPermissions_PermissionID_Permissions_PermissionID
        BEFORE INSERT
            ON AdminPermissions
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table AdminPermissions violates foreign key constraint fki_AdminPermissions_PermissionID_Permissions_PermissionID") 
     WHERE NEW.PermissionID IS NOT NULL AND 
           (
               SELECT PermissionID
                 FROM Permissions
                WHERE PermissionID = NEW.PermissionID
           )
           IS NULL;
END;


-- Trigger: fki_Contacts_ContactID_Users_UserID
CREATE TRIGGER fki_Contacts_ContactID_Users_UserID
        BEFORE INSERT
            ON Contacts
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Contacts violates foreign key constraint fki_Contacts_ContactID_Users_UserID") 
     WHERE (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.ContactID
           )
           IS NULL;
END;


-- Trigger: fki_Contacts_UserID_Users_UserID
CREATE TRIGGER fki_Contacts_UserID_Users_UserID
        BEFORE INSERT
            ON Contacts
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Contacts violates foreign key constraint fki_Contacts_UserID_Users_UserID") 
     WHERE NEW.UserID IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.UserID
           )
           IS NULL;
END;


-- Trigger: fki_GroupMessages_GroupID_Groups_GroupID
CREATE TRIGGER fki_GroupMessages_GroupID_Groups_GroupID
        BEFORE INSERT
            ON GroupMessages
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table GroupMessages violates foreign key constraint fki_GroupMessages_GroupID_Groups_GroupID") 
     WHERE NEW.GroupID IS NOT NULL AND 
           (
               SELECT GroupID
                 FROM Groups
                WHERE GroupID = NEW.GroupID
           )
           IS NULL;
END;


-- Trigger: fki_GroupMessages_MessageID_Messages_MessageID
CREATE TRIGGER fki_GroupMessages_MessageID_Messages_MessageID
        BEFORE INSERT
            ON GroupMessages
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table GroupMessages violates foreign key constraint fki_GroupMessages_MessageID_Messages_MessageID") 
     WHERE NEW.MessageID IS NOT NULL AND 
           (
               SELECT MessageID
                 FROM Messages
                WHERE MessageID = NEW.MessageID
           )
           IS NULL;
END;


-- Trigger: fki_GroupMessages_SenderID_Users_UserID
CREATE TRIGGER fki_GroupMessages_SenderID_Users_UserID
        BEFORE INSERT
            ON GroupMessages
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table GroupMessages violates foreign key constraint fki_GroupMessages_SenderID_Users_UserID") 
     WHERE NEW.SenderID IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.SenderID
           )
           IS NULL;
END;


-- Trigger: fki_Groups_GroupPicture_Media_MediaID
CREATE TRIGGER fki_Groups_GroupPicture_Media_MediaID
        BEFORE INSERT
            ON Groups
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Groups violates foreign key constraint fki_Groups_GroupPicture_Media_MediaID") 
     WHERE NEW.GroupPicture IS NOT NULL AND 
           (
               SELECT MediaID
                 FROM Media
                WHERE MediaID = NEW.GroupPicture
           )
           IS NULL;
END;


-- Trigger: fki_Groups_Owner_Users_UserID
CREATE TRIGGER fki_Groups_Owner_Users_UserID
        BEFORE INSERT
            ON Groups
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Groups violates foreign key constraint fki_Groups_Owner_Users_UserID") 
     WHERE NEW.Owner IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.Owner
           )
           IS NULL;
END;


-- Trigger: fki_Messages_Attachment_Media_MediaID
CREATE TRIGGER fki_Messages_Attachment_Media_MediaID
        BEFORE INSERT
            ON Messages
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Messages violates foreign key constraint fki_Messages_Attachment_Media_MediaID") 
     WHERE NEW.Attachment IS NOT NULL AND 
           (
               SELECT MediaID
                 FROM Media
                WHERE MediaID = NEW.Attachment
           )
           IS NULL;
END;


-- Trigger: fki_Messages_ReplyMessageID_Messages_MessageID
CREATE TRIGGER fki_Messages_ReplyMessageID_Messages_MessageID
        BEFORE INSERT
            ON Messages
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Messages violates foreign key constraint fki_Messages_ReplyMessageID_Messages_MessageID") 
     WHERE NEW.ReplyMessageID IS NOT NULL AND 
           (
               SELECT MessageID
                 FROM Messages
                WHERE MessageID = NEW.ReplyMessageID
           )
           IS NULL;
END;


-- Trigger: fki_NotActivatedAccounts_UserID_Users_UserID
CREATE TRIGGER fki_NotActivatedAccounts_UserID_Users_UserID
        BEFORE INSERT
            ON NotActivatedAccounts
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table NotActivatedAccounts violates foreign key constraint fki_NotActivatedAccounts_UserID_Users_UserID") 
     WHERE (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.UserID
           )
           IS NULL;
END;


-- Trigger: fki_Participants_AdminID_Admins_AdminID
CREATE TRIGGER fki_Participants_AdminID_Admins_AdminID
        BEFORE INSERT
            ON Participants
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Participants violates foreign key constraint fki_Participants_AdminID_Admins_AdminID") 
     WHERE NEW.AdminID IS NOT NULL AND 
           (
               SELECT AdminID
                 FROM Admins
                WHERE AdminID = NEW.AdminID
           )
           IS NULL;
END;


-- Trigger: fki_Participants_GroupID_Groups_GroupID
CREATE TRIGGER fki_Participants_GroupID_Groups_GroupID
        BEFORE INSERT
            ON Participants
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Participants violates foreign key constraint fki_Participants_GroupID_Groups_GroupID") 
     WHERE NEW.GroupID IS NOT NULL AND 
           (
               SELECT GroupID
                 FROM Groups
                WHERE GroupID = NEW.GroupID
           )
           IS NULL;
END;


-- Trigger: fki_Participants_UserID_Users_UserID
CREATE TRIGGER fki_Participants_UserID_Users_UserID
        BEFORE INSERT
            ON Participants
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Participants violates foreign key constraint fki_Participants_UserID_Users_UserID") 
     WHERE NEW.UserID IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.UserID
           )
           IS NULL;
END;


-- Trigger: fki_Users_ProfilePicture_Media_MediaID
CREATE TRIGGER fki_Users_ProfilePicture_Media_MediaID
        BEFORE INSERT
            ON Users
BEGIN
    SELECT RAISE(ROLLBACK, "insert on table Users violates foreign key constraint fki_Users_ProfilePicture_Media_MediaID") 
     WHERE NEW.ProfilePicture IS NOT NULL AND 
           (
               SELECT MediaID
                 FROM Media
                WHERE MediaID = NEW.ProfilePicture
           )
           IS NULL;
END;


-- Trigger: fku_AdminPermissions_AdminID_Admins_AdminID
CREATE TRIGGER fku_AdminPermissions_AdminID_Admins_AdminID
        BEFORE UPDATE
            ON AdminPermissions
BEGIN
    SELECT RAISE(ROLLBACK, "update on table AdminPermissions violates foreign key constraint fku_AdminPermissions_AdminID_Admins_AdminID") 
     WHERE NEW.AdminID IS NOT NULL AND 
           (
               SELECT AdminID
                 FROM Admins
                WHERE AdminID = NEW.AdminID
           )
           IS NULL;
END;


-- Trigger: fku_AdminPermissions_PermissionID_Permissions_PermissionID
CREATE TRIGGER fku_AdminPermissions_PermissionID_Permissions_PermissionID
        BEFORE UPDATE
            ON AdminPermissions
BEGIN
    SELECT RAISE(ROLLBACK, "update on table AdminPermissions violates foreign key constraint fku_AdminPermissions_PermissionID_Permissions_PermissionID") 
     WHERE NEW.PermissionID IS NOT NULL AND 
           (
               SELECT PermissionID
                 FROM Permissions
                WHERE PermissionID = NEW.PermissionID
           )
           IS NULL;
END;


-- Trigger: fku_Contacts_ContactID_Users_UserID
CREATE TRIGGER fku_Contacts_ContactID_Users_UserID
        BEFORE UPDATE
            ON Contacts
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Contacts violates foreign key constraint fku_Contacts_ContactID_Users_UserID") 
     WHERE (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.ContactID
           )
           IS NULL;
END;


-- Trigger: fku_Contacts_UserID_Users_UserID
CREATE TRIGGER fku_Contacts_UserID_Users_UserID
        BEFORE UPDATE
            ON Contacts
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Contacts violates foreign key constraint fku_Contacts_UserID_Users_UserID") 
     WHERE NEW.UserID IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.UserID
           )
           IS NULL;
END;


-- Trigger: fku_GroupMessages_GroupID_Groups_GroupID
CREATE TRIGGER fku_GroupMessages_GroupID_Groups_GroupID
        BEFORE UPDATE
            ON GroupMessages
BEGIN
    SELECT RAISE(ROLLBACK, "update on table GroupMessages violates foreign key constraint fku_GroupMessages_GroupID_Groups_GroupID") 
     WHERE NEW.GroupID IS NOT NULL AND 
           (
               SELECT GroupID
                 FROM Groups
                WHERE GroupID = NEW.GroupID
           )
           IS NULL;
END;


-- Trigger: fku_GroupMessages_MessageID_Messages_MessageID
CREATE TRIGGER fku_GroupMessages_MessageID_Messages_MessageID
        BEFORE UPDATE
            ON GroupMessages
BEGIN
    SELECT RAISE(ROLLBACK, "update on table GroupMessages violates foreign key constraint fku_GroupMessages_MessageID_Messages_MessageID") 
     WHERE NEW.MessageID IS NOT NULL AND 
           (
               SELECT MessageID
                 FROM Messages
                WHERE MessageID = NEW.MessageID
           )
           IS NULL;
END;


-- Trigger: fku_GroupMessages_SenderID_Users_UserID
CREATE TRIGGER fku_GroupMessages_SenderID_Users_UserID
        BEFORE UPDATE
            ON GroupMessages
BEGIN
    SELECT RAISE(ROLLBACK, "update on table GroupMessages violates foreign key constraint fku_GroupMessages_SenderID_Users_UserID") 
     WHERE NEW.SenderID IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.SenderID
           )
           IS NULL;
END;


-- Trigger: fku_Groups_GroupPicture_Media_MediaID
CREATE TRIGGER fku_Groups_GroupPicture_Media_MediaID
        BEFORE UPDATE
            ON Groups
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Groups violates foreign key constraint fku_Groups_GroupPicture_Media_MediaID") 
     WHERE NEW.GroupPicture IS NOT NULL AND 
           (
               SELECT MediaID
                 FROM Media
                WHERE MediaID = NEW.GroupPicture
           )
           IS NULL;
END;


-- Trigger: fku_Groups_Owner_Users_UserID
CREATE TRIGGER fku_Groups_Owner_Users_UserID
        BEFORE UPDATE
            ON Groups
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Groups violates foreign key constraint fku_Groups_Owner_Users_UserID") 
     WHERE NEW.Owner IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.Owner
           )
           IS NULL;
END;


-- Trigger: fku_Messages_Attachment_Media_MediaID
CREATE TRIGGER fku_Messages_Attachment_Media_MediaID
        BEFORE UPDATE
            ON Messages
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Messages violates foreign key constraint fku_Messages_Attachment_Media_MediaID") 
     WHERE NEW.Attachment IS NOT NULL AND 
           (
               SELECT MediaID
                 FROM Media
                WHERE MediaID = NEW.Attachment
           )
           IS NULL;
END;


-- Trigger: fku_Messages_ReplyMessageID_Messages_MessageID
CREATE TRIGGER fku_Messages_ReplyMessageID_Messages_MessageID
        BEFORE UPDATE
            ON Messages
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Messages violates foreign key constraint fku_Messages_ReplyMessageID_Messages_MessageID") 
     WHERE NEW.ReplyMessageID IS NOT NULL AND 
           (
               SELECT MessageID
                 FROM Messages
                WHERE MessageID = NEW.ReplyMessageID
           )
           IS NULL;
END;



-- Trigger: fku_Participants_AdminID_Admins_AdminID
CREATE TRIGGER fku_Participants_AdminID_Admins_AdminID
        BEFORE UPDATE
            ON Participants
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Participants violates foreign key constraint fku_Participants_AdminID_Admins_AdminID") 
     WHERE NEW.AdminID IS NOT NULL AND 
           (
               SELECT AdminID
                 FROM Admins
                WHERE AdminID = NEW.AdminID
           )
           IS NULL;
END;


-- Trigger: fku_Participants_GroupID_Groups_GroupID
CREATE TRIGGER fku_Participants_GroupID_Groups_GroupID
        BEFORE UPDATE
            ON Participants
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Participants violates foreign key constraint fku_Participants_GroupID_Groups_GroupID") 
     WHERE NEW.GroupID IS NOT NULL AND 
           (
               SELECT GroupID
                 FROM Groups
                WHERE GroupID = NEW.GroupID
           )
           IS NULL;
END;


-- Trigger: fku_Participants_UserID_Users_UserID
CREATE TRIGGER fku_Participants_UserID_Users_UserID
        BEFORE UPDATE
            ON Participants
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Participants violates foreign key constraint fku_Participants_UserID_Users_UserID") 
     WHERE NEW.UserID IS NOT NULL AND 
           (
               SELECT UserID
                 FROM Users
                WHERE UserID = NEW.UserID
           )
           IS NULL;
END;


-- Trigger: fku_Users_ProfilePicture_Media_MediaID
CREATE TRIGGER fku_Users_ProfilePicture_Media_MediaID
        BEFORE UPDATE
            ON Users
BEGIN
    SELECT RAISE(ROLLBACK, "update on table Users violates foreign key constraint fku_Users_ProfilePicture_Media_MediaID") 
     WHERE NEW.ProfilePicture IS NOT NULL AND 
           (
               SELECT MediaID
                 FROM Media
                WHERE MediaID = NEW.ProfilePicture
           )
           IS NULL;
END;

insert into Permissions(PermissionName,PermissionDescrption)
values('AddUsers','This Permission allows Admins to Add new Users To their Group'),
('RemoveUsers','This Permission allows Admins to Remove Users From their Group'),
('Mute','This Permission allows Admins to Mute users in their Group');


insert into Admins(AdminType)
values('OWNER'),('ADMIN')

insert into AdminPermissions(AdminID,PermissionID)
values(1,1),(1,2),(1,3),(2,1)

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;


  ''';
}
