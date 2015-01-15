part of issuelib;

class AuthenticationService {
  
  Store store;
  
  AuthenticationService(this.store);
  
  void createUser(User user) {
    this.store.storeUser(user);
  }
}