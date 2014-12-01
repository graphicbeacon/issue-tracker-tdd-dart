import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {
  
  // IssueBoardService tests
  test('calling getAllIssues on issueBoardService returns all issues as an IssueBoard', (){
    // Arrange
    var issues = new List<Issue>()
      ..add(new Issue (dueDate: new DateTime.now()))
      ..add(new Issue (dueDate: new DateTime.now()));
      
    var issueStore = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(issues);
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
    
    // Act
    IssueBoard board = issueBoardService.getAllIssues();
    
    // Assert
    assert(board.issues != null);
    assert(board.issues.length == issues.length);
  });
  
  test('calling getAllIssues on issueBoardService returns all issues as an IssueBoard ordered by dueDate descending.', (){
    // Arrange
    var issues = new List<Issue>()
      ..add(new Issue (dueDate: DateTime.parse('2014-11-13 14:59:00')))
      ..add(new Issue (dueDate: DateTime.parse('2014-11-13 17:59:00')));
      
    var issueStore = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(new List<Issue>.from(issues));
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
    
    // Act
    IssueBoard board = issueBoardService.getAllIssues();
    
    // Assert
    assert(board.issues.length == issues.length);
    assert(board.issues[0].dueDate.isAtSameMomentAs(issues[1].dueDate));
    assert(board.issues[1].dueDate.isAtSameMomentAs(issues[0].dueDate));
  });
  
  test('calling getIssueByName on IssueBoardService returns all issues as an IssueBoard with name', () {
    
    // Arrange
    var issues = new List<Issue>()
      ..add(new Issue (title: 'Create blah'))
      ..add(new Issue (title: 'Create blah feature'))
      ..add(new Issue (title: 'Delete pingdom alerts'));
          
    var issueStore = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(new List<Issue>.from(issues));
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
        
    // Act
    IssueBoard board = issueBoardService.getIssuesByName('Create');
    
    // Assert
    assert(board.issues.length == 2);
  });
  
  test('calling getIssuesByProjectName on IssueBoardService returns all issues filtered by project name', () {
    // Arrange
    var projects = new List<Project>()
      ..add(new Project(id: 1, name: 'Project 1'))
      ..add(new Project(id: 2, name: 'Project 2'));
    
    var issues = new List<Issue>()
      ..add(new Issue (title: 'Issue 1', projectId: 1))
      ..add(new Issue (title: 'Issue 2', projectId: 2))
      ..add(new Issue (title: 'Issue 3', projectId: 2));
    
    var store = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(issues)
      ..when(callsTo('getAllProjects')).alwaysReturn(projects);
    
    IssueBoardService issueBoardService = new IssueBoardService(store);  
        
    // Act
    IssueBoard board = issueBoardService.getIssuesByProjectName('Project 1');    
        
    // Assert
    assert(board.issues.length == 1);
  });
  
}

