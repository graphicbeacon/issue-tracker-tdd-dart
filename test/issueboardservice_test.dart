import 'package:unittest/unittest.dart';
import 'package:dartmocks/dartmocks.dart';

import '../lib/issuelib.dart';

void main() {
  
  // IssueBoardService tests
  test('calling getAllIssues on issueBoardService returns all issues', (){
    // Arrange
    var issues = new List<Issue>()
      ..add(new Issue (dueDate: new DateTime.now()))
      ..add(new Issue (dueDate: new DateTime.now()));
      
    var issueStore = stub('IssueStore')
        ..stub('getAllIssues').andReturn(issues);
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
    
    // Act
    IssueBoard board = issueBoardService.getAllIssues();
    
    // Assert
    assert(board.issues != null);
    assert(board.issues.length == issues.length);
  });
  
  test('calling getAllIssues on issueBoardService returns all issues ordered by dueDate descending.', (){
    // Arrange
    var issues = new List<Issue>()
      ..add(new Issue (dueDate: DateTime.parse('2014-11-13 14:59:00')))
      ..add(new Issue (dueDate: DateTime.parse('2014-11-13 17:59:00')));
      
    var issueStore = stub('IssueStore')
        ..stub('getAllIssues').andReturn(new List<Issue>.from(issues));
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
    
    // Act
    IssueBoard board = issueBoardService.getAllIssues();
    
    // Assert
    assert(board.issues.length == issues.length);
    assert(board.issues[0].dueDate.isAtSameMomentAs(issues[1].dueDate));
    assert(board.issues[1].dueDate.isAtSameMomentAs(issues[0].dueDate));
  });
}

