part of issuelib;

class AuthenticationService {
  
  Store store;
  HashingManager hashingManager;
  
  AuthenticationService(this.store, this.hashingManager);
  
  void createUser(User user) {
    
    user.passwordSalt = this.hashingManager.generateSalt();
    user.passwordHash = this.hashingManager.generateHash(user.plainTextPassword, user.passwordSalt);
    
    this.store.storeUser(user);
  }
}