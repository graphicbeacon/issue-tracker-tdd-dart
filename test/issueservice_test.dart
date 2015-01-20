import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {
  
  test('calling createIssue on IssueService stores issue', () {
    
    // Arrange
    var user = new User('Bob', 'Doe', 'bob', '');
    var userSession = new UserSession('token', user.username);
    
    var issueStore = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(true)
        ..when(callsTo('hasIssue')).alwaysReturn(false)
        ..when(callsTo('getUserSession')).alwaysReturn(userSession)
        ..when(callsTo('getUser')).alwaysReturn(user);
    
    IssueService issueService = new IssueService(issueStore, '');
    String id = '123';
    String title = '';
    String description = '';
    DateTime dueDate = new DateTime.now();
    IssueStatus issueStatus = new IssueStatus.opened();
    String projectName = '';
    
    // Act
    issueService.createIssue(id, title, description, dueDate, issueStatus, projectName, '');
    
    // Assert
    issueStore.getLogs(callsTo('storeIssue')).verify(happenedOnce);
  });
  
  test('calling createIssue on IssueService stores issue with correct values', () {
    
    // Arrange
    var user = new User('Bob', 'Doe', 'bob', '');
    var userSession = new UserSession('token', user.username);
    
    Issue expectedIssue = new Issue(
        id: '123',
        title : 'Lorem ipsum dolor sit amet',
        description : 'This is the issue description.',
        dueDate : new DateTime.now(),
        status : new IssueStatus.opened(),
        projectName : 'Project 1',
        createdBy: 'Bob Doe',
        assignedTo: 'Bob Doe'
    );
    
    var issueStore = new StoreMock()
      ..when(callsTo('hasProject')).alwaysReturn(true)
      ..when(callsTo('hasIssue')).alwaysReturn(false)
      ..when(callsTo('getUserSession')).alwaysReturn(userSession)
      ..when(callsTo('getUser')).alwaysReturn(user);
     
    IssueService issueService = new IssueService(issueStore, '');
    
    // Act
    issueService.createIssue(expectedIssue.id, expectedIssue.title, expectedIssue.description, 
        expectedIssue.dueDate, expectedIssue.status, expectedIssue.projectName, '');
     
    // Assert
    issueStore.getLogs(callsTo('storeIssue', expectedIssue)).verify(happenedOnce);
  });
  
  test('calling createIssue on IssueService throws if the specified project name does not exist in store', () {
    
      // Arrange
      var issueStore = new StoreMock()
        ..when(callsTo('hasIssue')).alwaysReturn(false)
        ..when(callsTo('hasProject')).alwaysReturn(false);
        
      IssueService issueService = new IssueService(issueStore, '');
       
      String title = 'Lorem ipsum dolor sit amet';
      String description = 'This is the issue description.';
      DateTime dueDate = new DateTime.now();
      IssueStatus issueStatus = new IssueStatus.opened();
      String projectName = 'Project 1';
        
      // Act, Assert
      expect(() => issueService.createIssue('123', title, description, dueDate, issueStatus, projectName, ''),
          throwsArgumentError);
    });
  
  test('calling createIssue on IssueService takes in UserSession token and populates createdBy and assignedTo fields', () {
    // Arrange
    var user = new User('Bob', 'Doe', 'bob', '');
    var userSession = new UserSession('token', user.username);

    Issue expectedIssue = new Issue(
            id: '123',
            title : 'Lorem ipsum dolor sit amet',
            description : 'This is the issue description.',
            dueDate : new DateTime.now(),
            status : new IssueStatus.opened(),
            projectName : 'Project 1',
            createdBy: '${user.firstName} ${user.lastName}',
            assignedTo: '${user.firstName} ${user.lastName}'
        );
    
    var issueStore = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(true)
        ..when(callsTo('hasIssue')).alwaysReturn(false)
        ..when(callsTo('getUserSession')).alwaysReturn(userSession)
        ..when(callsTo('getUser')).alwaysReturn(user);
    
    IssueService issueService = new IssueService(issueStore, '');
    
    // Act
    issueService.createIssue('123', expectedIssue.title, expectedIssue.description, 
        expectedIssue.dueDate, expectedIssue.status, expectedIssue.projectName, userSession.sessionToken);
    
    // Assert
    issueStore.getLogs(callsTo('storeIssue', expectedIssue)).verify(happenedOnce);
  });
  
  test('calling createIssue on IssueService will throw an exception when the user is not signed in', () {
     // Arrange
     var userSession = new UserSession('token', 'Bob');
    
     Issue issue = new Issue(
         id: '123',
         title : 'Lorem ipsum dolor sit amet',
         description : 'This is the issue description.',
         dueDate : new DateTime.now(),
         status : new IssueStatus.opened(),
         projectName : 'Project 1'
     );
     
     var issueStore = new StoreMock()
         ..when(callsTo('hasProject')).alwaysReturn(true)
         ..when(callsTo('hasIssue')).alwaysReturn(false)
         ..when(callsTo('getUserSession')).alwaysReturn(null);
     
     IssueService issueService = new IssueService(issueStore, '');
     
     // Act, Assert
     expect(() => issueService.createIssue(issue.id, issue.title, issue.description, 
         issue.dueDate, issue.status, issue.projectName, userSession.sessionToken), throwsArgumentError);
     
  });
  
  test('calling createIssue on IssueService will throw an exception when id already exists', () {
      // Arrange
      var userSession = new UserSession('token', 'Bob');
       
      Issue issue = new Issue(
          id: '123',
          title : 'Lorem ipsum dolor sit amet',
          description : 'This is the issue description.',
          dueDate : new DateTime.now(),
          status : new IssueStatus.opened(),
          projectName : 'Project 1'
      );
      
      var issueStore = new StoreMock()
        ..when(callsTo('hasIssue')).alwaysReturn(true);
      
      IssueService issueService = new IssueService(issueStore, '');
      
      // Act, Assert
      expect(() => issueService.createIssue(issue.id, issue.title, issue.description, 
          issue.dueDate, issue.status, issue.projectName, userSession.sessionToken), throwsArgumentError);
  });
  
  test('saving saveAttachment on IssueService will populate the attachment list on the issue object', () {
      // Arrange
      const fileName = 'file';
           
      Issue issue = new Issue(
          id: '123',
          title : 'Lorem ipsum dolor sit amet',
          description : 'This is the issue description.',
          dueDate : new DateTime.now(),
          status : new IssueStatus.opened(),
          projectName : 'Project 1'
      );
      
      var issueStore = new StoreMock()
          ..when(callsTo('hasIssue')).alwaysReturn(true)
          ..when(callsTo('getIssue')).alwaysReturn(issue)
          ..when(callsTo('hasUserSession')).alwaysReturn(true);

      IssueService issueService = new IssueService(issueStore, '');
      
      // Act
      issueService.saveAttachment(issue.id, '', fileName);
      
      // Assert
      issueStore.getLogs(callsTo('getIssue')).verify(happenedOnce);
      issueStore.getLogs(callsTo('updateIssue')).verify(happenedOnce);

      assert(issue.attachments.length == 1);
      assert(issue.attachments[0].name == fileName);
  });
  
  test('saving saveAttachment on IssueService will throw error if issue id does not exist', () {
      // Arrange      
      var issueStore = new StoreMock()
          ..when(callsTo('getIssue')).alwaysReturn(null)
          ..when(callsTo('hasUserSession')).alwaysReturn(true);

      IssueService issueService = new IssueService(issueStore, '');
      
      // Act, Assert
      expect(() => issueService.saveAttachment('123', '', 'file name'), throwsArgumentError);

  });
  
  test('saving saveAttachment on IssueService will throw error if user session does not exist', () {
      // Arrange     
      const sessionToken = 'token';
      var issueStore = new StoreMock()
          ..when(callsTo('getIssue')).alwaysReturn(new Issue())
          ..when(callsTo('hasUserSession')).alwaysReturn(false);

      IssueService issueService = new IssueService(issueStore, '');
      
      // Act, Assert
      expect(() => issueService.saveAttachment('123', sessionToken, 'file name'), throwsArgumentError);

  });
  
  test('saving saveAttachment on IssueService will set file location on attachment', () {
      // Arrange
      const fileName = 'file';
      const attachmentFilesDirectory = 'path/to/file';
      
      Issue issue = new Issue(
          id: '123',
          title : 'Lorem ipsum dolor sit amet',
          description : 'This is the issue description.',
          dueDate : new DateTime.now(),
          status : new IssueStatus.opened(),
          projectName : 'Project 1'
      );
      
      var issueStore = new StoreMock()
          ..when(callsTo('hasIssue')).alwaysReturn(true)
          ..when(callsTo('getIssue')).alwaysReturn(issue)
          ..when(callsTo('hasUserSession')).alwaysReturn(true);

      IssueService issueService = new IssueService(issueStore, attachmentFilesDirectory);
      
      // Act
      issueService.saveAttachment(issue.id, '', fileName);
      
      // Assert
      assert(issue.attachments.length == 1);
      assert(issue.attachments[0].location == '${attachmentFilesDirectory}/${issue.id}/${fileName}');
  });
  
//  test('calling saveAttachment on IssueService will create attachment file in specified location', () {
//     // Arrange
//     var userSession = new UserSession('token', 'Bob');
//    
//     // Act
//    
//     // Assert
//  });
}

