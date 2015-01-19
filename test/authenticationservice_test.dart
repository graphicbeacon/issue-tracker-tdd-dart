import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {
 
  test('calling createUser on AuthenticationService will store user information', () {
    // Arrange
    var store = new StoreMock();
    var hashingManager = new HashingManagerMock();
    
    var user = new User('First Name', 'Last Name', 'myUserName', 'myPlainTextPassword');
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act
    authenticationService.createUser(user);
    
    // Assert
    store.getLogs(callsTo('storeUser')).verify(happenedOnce);
  });
  
  test('calling createUser on AuthenticationService will hash password prior to storing', () {
    // Arrange
    const expectedSalt = 'Salt';
    const expectedHash = 'Pepper';
    
    var store = new StoreMock();
    var hashingManager = new HashingManagerMock()
        ..when(callsTo('generateSalt')).alwaysReturn(expectedSalt)
        ..when(callsTo('generateHash')).alwaysReturn(expectedHash);
    
    
    var password = 'hello';
    var user = new User('First Name', 'Last Name', 'myUserName', password);
    var authenticationService = new AuthenticationService(store, hashingManager);
     
    // Act
    authenticationService.createUser(user);
     
    // Assert
    hashingManager.getLogs(callsTo('generateSalt')).verify(happenedOnce);
    hashingManager.getLogs(callsTo('generateHash')).verify(happenedOnce);
    
    assert(user.passwordSalt == expectedSalt);
    assert(user.passwordHash == expectedHash);
  });
  
}