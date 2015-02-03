part of issuelib;

class UserSession extends Object with Exportable {
  
  @export String sessionToken;
  @export String username;
  
  UserSession();
  UserSession.create(this.sessionToken, this.username);
  
  bool operator ==(o) {
    return o is UserSession && 
        sessionToken == o.sessionToken &&
        username == o.username;  
  }
}