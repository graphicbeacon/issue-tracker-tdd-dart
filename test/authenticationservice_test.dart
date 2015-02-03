import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';
import 'package:uuid/uuid.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {
 
  test('calling createUser on AuthenticationService will store user information', () async {
    // Arrange
    var store = new StoreMock()
        ..when(callsTo('hasUser')).alwaysReturn(false);
    var hashingManager = new HashingManagerMock();
    
    var user = new User.create('First Name', 'Last Name', 'myUserName', 'myPlainTextPassword');
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act
    await authenticationService.createUser(user);
    
    // Assert
    store.getLogs(callsTo('storeUser')).verify(happenedOnce);
  });
  
  test('calling createUser on AuthenticationService will hash password prior to storing', () async {
    // Arrange
    const expectedSalt = 'Salt';
    const expectedHash = 'Pepper';
    
    var store = new StoreMock()
        ..when(callsTo('hasUser')).alwaysReturn(false);
    var hashingManager = new HashingManagerMock()
        ..when(callsTo('generateSalt')).alwaysReturn(expectedSalt)
        ..when(callsTo('generateHash')).alwaysReturn(expectedHash);
    
    
    var password = 'hello';
    var user = new User.create('First Name', 'Last Name', 'myUserName', password);
    var authenticationService = new AuthenticationService(store, hashingManager);
     
    // Act
    await authenticationService.createUser(user);
     
    // Assert
    hashingManager.getLogs(callsTo('generateSalt')).verify(happenedOnce);
    hashingManager.getLogs(callsTo('generateHash')).verify(happenedOnce);
    
    assert(user.passwordSalt == expectedSalt);
    assert(user.passwordHash == expectedHash);
  });
  
  test('calling login on the AuthenticationService will login user and return token', () async {
    // Arrange
    var user = new User.create('first','last','user','pass')
            ..passwordSalt = 'salt';
    
    var store = new StoreMock()
        ..when(callsTo('getUser')).alwaysReturn(user);
    
    var hashingManager = new HashingManagerMock();
    var uuid = new Uuid();
    
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act
    var token = await authenticationService.login('username', 'plainTextPassword');
    
    // Assert
    store.getLogs(callsTo('storeUserSession')).verify(happenedOnce);
    assert(uuid.parse(token).length == 16);
  });
  
  test('calling login on the AuthenticationService will store user session information', () async {
      // Arrange
      const username = 'username';
      var user = new User.create('first','last','user','pass')
        ..passwordSalt = 'salt';
      
      var store = new StoreMock()
          ..when(callsTo('getUser')).alwaysReturn(user);
      
      var hashingManager = new HashingManagerMock();
      
      var authenticationService = new AuthenticationService(store, hashingManager);
      
      // Act
      var token = await authenticationService.login(username, 'plainTextPassword');
      
      // Assert
      var userSession = new UserSession.create(token, username);
      store.getLogs(callsTo('storeUserSession', userSession)).verify(happenedOnce);
    });
  
  test('calling login on the AuthenticationService will check password against hash', () async {
      // Arrange
      var password = 'pasword123';
      var user = new User.create('', '', 'myUserName', '')
        ..passwordSalt = 'hoho'
        ..passwordHash = 'hohoho';
    
      var store = new StoreMock()
        ..when(callsTo('getUser')).alwaysReturn(user);
      
      var hashingManager = new HashingManagerMock()
        ..when(callsTo('generateHash')).alwaysReturn(user.passwordHash);
      
      var authenticationService = new AuthenticationService(store, hashingManager);
      
      // Act
      var token = await authenticationService.login(user.username, password);
      
      // Assert
      store.getLogs(callsTo('getUser', user.username)).verify(happenedOnce);
      hashingManager.getLogs(callsTo('generateHash', password, user.passwordSalt)).verify(happenedOnce);
    });
  
  test('calling login on the AuthenticationService will throw ArgumentError when password does not match hash', () async {
      // Arrange
      var password = 'pasword123';
      var user = new User.create('', '', 'myUserName', '')
        ..passwordSalt = 'hoho'
        ..passwordHash = 'hohoho';
    
      var store = new StoreMock()
        ..when(callsTo('getUser')).alwaysReturn(user);
      
      var hashingManager = new HashingManagerMock()
        ..when(callsTo('generateHash')).alwaysReturn(user.passwordHash + '1263576');
      
      var authenticationService = new AuthenticationService(store, hashingManager);
      
      // Act, Assert
      try {
        await authenticationService.login(user.username, password);
        assert(false); // Ensure that catch block gets hit
      } catch(e) {
        assert(e is ArgumentError);
      }
    });
  
  test('calling logoff on the AuthenticationService will remove UserSession from store', () async {
    // Arrange
    var sessionToken = 'myToken';
    
    var store = new StoreMock();
    var hashingManager = new HashingManagerMock();
    
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act
    await authenticationService.logout(sessionToken);
    
    // Assert
    store.getLogs(callsTo('deleteUserSession', sessionToken)).verify(happenedOnce);
  });

  test('calling createUser on the AuthenticationService will throw error is username is not unique', () async {
    // Arrange
    var user = new User.create('', '', 'myUserName', '');
  
    var store = new StoreMock()
      ..when(callsTo('hasUser')).alwaysReturn(true);
    
    var hashingManager = new HashingManagerMock();
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act, Assert
    try {
      await authenticationService.createUser(user);
      assert(false); // Ensure that catch block gets hit
    } catch(e) {
      assert(e is ArgumentError);
    }
  });

  test('calling createUser on the AuthenticationService will not store password as plain text', () async {
    // Arrange
    var user = new User.create('first', 'last', 'myUserName', 'plainTextPassword');
    var expectedUser = new User.create(user.firstName, user.lastName, user.username, '');
    
    var store = new StoreMock()
      ..when(callsTo('hasUser')).alwaysReturn(false);
    
    var hashingManager = new HashingManagerMock();
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act
    await authenticationService.createUser(user);
    
    // Assert
    store.getLogs(callsTo('storeUser', expectedUser)).verify(happenedOnce);
    
  });

  
  test('calling login on the AuthenticationService will throw ArgumentError when user does not exist', () async {
    // Arrange    
    var store = new StoreMock()
      ..when(callsTo('getUser')).alwaysReturn(null);
    
    var hashingManager = new HashingManagerMock();
    
    var authenticationService = new AuthenticationService(store, hashingManager);
    
    // Act, Assert
    try {
      await authenticationService.login('bob', 'password');
      assert(false); // Ensure that catch block gets hit
    } catch (e) {
      assert(e is ArgumentError);
    }
  });
  
  
}