part of issuelib;

class User extends Object with Exportable {
  @export String firstName;
  @export String lastName;
  @export String username;
  @export String plainTextPassword;
  
  @export String passwordSalt;
  @export String passwordHash;
  
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