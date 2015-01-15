import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

void main() {
 
  test('calling createUser on AuthenticationService will store user information', () {
    // Arrange
    var store = new StoreMock();
    
    var user = new User('First Name', 'Last Name', 'myUserName', 'myPlainTextPassword');
    var authenticationService = new AuthenticationService(store);
    
    // Act
    authenticationService.createUser(user);
    
    // Assert
    store.getLogs(callsTo('storeUser')).verify(happenedOnce);
  });
  
  test('calling createUser on AuthenticationService will hash password prior to storing', () {
    // Arrange
    var store = new StoreMock();
     
    var user = new User('First Name', 'Last Name', 'myUserName', password);
    var authenticationService = new AuthenticationService(store);
     
    // Act
    authenticationService.createUser(user);
     
    // Assert
    store.getLogs(callsTo('storeUser')).verify(happenedOnce);
  });
  
}