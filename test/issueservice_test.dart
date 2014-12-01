import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {
  
  test('calling createIssue on IssueService stores issue', () {
    
    // Arrange
    var issueStore = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(true);
    
    IssueService issueService = new IssueService(issueStore);
    String title = '';
    String description = '';
    DateTime dueDate = new DateTime.now();
    IssueStatus issueStatus = new IssueStatus.opened();
    int projectId = 0;
    
    // Act
    issueService.createIssue(title, description, dueDate, issueStatus, projectId);
    
    // Assert
    issueStore.getLogs(callsTo('storeIssue')).verify(happenedOnce);
  });
  
  test('calling createIssue on IssueService stores issue with correct values', () {
    // Arrange
    Issue expectedIssue = new Issue(
        title : 'Lorem ipsum dolor sit amet',
        description : 'This is the issue description.',
        dueDate : new DateTime.now(),
        status : new IssueStatus.opened(),
        projectId : 1
    );
    
    var issueStore = new StoreMock()
      ..when(callsTo('hasProject')).alwaysReturn(true);
     
    IssueService issueService = new IssueService(issueStore);
    
    // Act
    issueService.createIssue(expectedIssue.title, expectedIssue.description, 
        expectedIssue.dueDate, expectedIssue.status, expectedIssue.projectId);
     
    // Assert
    issueStore.getLogs(callsTo('storeIssue', expectedIssue)).verify(happenedOnce);
  });
  
  test('calling createIssue on IssueService throws if the specified projectId does not exist in store', () {
      // Arrange
      var issueStore = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(false);
        
      IssueService issueService = new IssueService(issueStore);
       
      String title = 'Lorem ipsum dolor sit amet';
      String description = 'This is the issue description.';
      DateTime dueDate = new DateTime.now();
      IssueStatus issueStatus = new IssueStatus.opened();
      int projectId = 2;
        
      // Act, Assert
      expect(() => issueService.createIssue(title, description, dueDate, issueStatus, projectId),
          throwsArgumentError);
    });
}

