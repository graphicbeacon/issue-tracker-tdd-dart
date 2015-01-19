part of issuelib;

class UserSession {
  
  String sessionToken;
  String username;
  
  UserSession(String this.sessionToken, String this.username);
  
  bool operator ==(o) {
    return o is UserSession && 
        sessionToken == o.sessionToken &&
        username == o.username;  
  }
}