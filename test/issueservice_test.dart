import 'package:unittest/unittest.dart';
import 'package:dartmocks/dartmocks.dart';

import '../lib/issuelib.dart';
void main() {
  
  test('calling createIssue on IssueService stores issue', () {
    
    // Arrange
    var issueStore = mock('Store')
        ..shouldReceive('storeIssue');
    
    IssueService issueService = new IssueService(issueStore);
    String title = '';
    String description = '';
    DateTime dueDate = new DateTime.now();
    IssueStatus issueStatus = new IssueStatus.opened();
    
    // Act
    issueService.createIssue(title, description, dueDate, issueStatus);
    
    // Assert
    issueStore.verify();
  });
  
  test('calling createIssue on IssueService stores issue with correct values', () {
    // Arrange
    Issue issue = null;
    
    var issueStore = stub('Store')
      ..stub('storeIssue').andCall((receivedIssue) => issue = receivedIssue);
     
    IssueService issueService = new IssueService(issueStore);
    
    String title = 'Lorem ipsum dolor sit amet';
    String description = 'This is the issue description.';
    DateTime dueDate = new DateTime.now();
    IssueStatus issueStatus = new IssueStatus.opened();
     
    // Act
    issueService.createIssue(title, description, dueDate, issueStatus);
     
    // Assert
    assert(issue != null);
    assert(issue.title == title);
    assert(issue.description == description);
    assert(issue.dueDate == dueDate);
    assert(issue.status == issueStatus);
  });
}

