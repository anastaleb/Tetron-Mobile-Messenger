import 'dart:core';
import 'dart:io';

class User {
  final int UserID;
  String Fullname;
  String Nickname;
  String Password;
  String Bio;
  String Email;
  Media ProfilePicture;
  DateTime LastSeen;
  UserStatus Status;
  List<User> BlockedUsers;
  List<User> Contacts;
  List<Group> Groups;

  User(
      this.UserID,
      this.Fullname,
      this.Nickname,
      this.Password,
      this.Bio,
      this.Email,
      this.ProfilePicture,
      this.LastSeen,
      this.Status,
      this.BlockedUsers,
      this.Contacts,
      this.Groups);

  User.meh(this.UserID);
}

enum UserStatus { ONLINE, OFFLINE }

class Media {
  int MediaID;
  String MediaName;
  String Size;
  String Path;
  File MediaFile;
  Media(this.MediaID, this.MediaName, this.Size, this.Path, this.MediaFile);
}

class Group {
  int GroupID;
  String GroupName;
  String Description;
  DateTime CreateTime;
  Media GroupPicture;
  User Owner;
  GroupType Type;
  List<User> Participants;
  List<Message> Messages;
  List<Admin> Admins;
  Group(
      this.GroupID,
      this.GroupName,
      this.Description,
      this.CreateTime,
      this.GroupPicture,
      this.Owner,
      this.Type,
      this.Participants,
      this.Messages,
      this.Admins);
}

enum GroupType { Channel, Group, Conversation }

class Message {
  int MessageID;
  DateTime SentTime;
  String Content;
  Media Attachment;
  Message MessageToReply;
  Message(this.MessageID, this.SentTime, this.Content, this.Attachment,
      this.MessageToReply);
}

enum Permission { AddUsers, RemoveUsers, BlockUsers, MuteUsers }

enum AdminType { Owner, Admin }

class Admin {
  List<Permission> Permissions;

  Admin(this.Permissions, this.user);

  User user;
}

class ChatRoom {
  final User sender;
  final List<Message> messages;

  ChatRoom({this.sender, this.messages});
}
