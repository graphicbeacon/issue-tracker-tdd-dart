part of issuelib;

class User {
  String firstName;
  String lastName;
  String userName;
  String plainTextPassword;
  
  String passwordSalt;
  String passwordHash;
  
  User(this.firstName, this.lastName, this.userName, this.plainTextPassword);
}