part of issuelib;

class UserSession extends Object with Exportable {
  
  @export String sessionToken;
  @export String username;
  
  UserSession(String this.sessionToken, String this.username);
  
  bool operator ==(o) {
    return o is UserSession && 
        sessionToken == o.sessionToken &&
        username == o.username;  
  }
}