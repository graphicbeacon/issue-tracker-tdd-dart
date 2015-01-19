part of issuelib;

class User {
  String firstName;
  String lastName;
  String username;
  String plainTextPassword;
  
  String passwordSalt;
  String passwordHash;
  
  User(this.firstName, this.lastName, this.username, this.plainTextPassword);
  
  bool operator ==(o) {
      return o is User &&
          firstName == o.firstName &&
          lastName == o.lastName &&
          username == o.username &&
          plainTextPassword == o.plainTextPassword &&
          passwordSalt == o.passwordSalt &&
          passwordHash == o.passwordHash;  
    }
}