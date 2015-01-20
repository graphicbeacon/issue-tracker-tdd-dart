part of issuelib;

class AuthenticationService {
  
  Store store;
  HashingManager hashingManager;
  
  AuthenticationService(this.store, this.hashingManager);
  
  void createUser(User user) {

    if(this.store.hasUser(user.username))
      throw new ArgumentError('Username already exists');
    
    user.passwordSalt = this.hashingManager.generateSalt();
    user.passwordHash = this.hashingManager.generateHash(user.plainTextPassword, user.passwordSalt);
    
    /// Do not store plain text password   
    user.plainTextPassword = '';
    
    this.store.storeUser(user);
  }
  
  String login(String username, String plainTextPassword){
    var user = this.store.getUser(username);
    if(user == null)
      throw new ArgumentError("Could not find user in our system");
    
    var passwordHash = this.hashingManager.generateHash(plainTextPassword, user.passwordSalt);
    
    if (passwordHash != user.passwordHash)
      throw new ArgumentError("The password used to login did not match the password saved to the store.");
    
    var uuid = new Uuid();
    var sessionToken = uuid.v1();
    
    var userSession = new UserSession(sessionToken, username);
    this.store.storeUserSession(userSession);
    
    return sessionToken;
  }
  
  void logout(String sessionToken){
    this.store.deleteUserSession(sessionToken);
  }
}