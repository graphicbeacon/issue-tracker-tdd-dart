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
    IssueBoard board = issueBoardService.getAllIssues(null);
    
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
    IssueBoard board = issueBoardService.getAllIssues(null);
    
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
    IssueBoard board = issueBoardService.getIssuesByName('Create', null);
    
    // Assert
    assert(board.issues.length == 2);
  });
  
  test('calling getIssuesByProjectName on IssueBoardService returns all issues filtered by project name', () {
    // Arrange
    var projects = new List<Project>()
      ..add(new Project(name: 'Project 1'))
      ..add(new Project(name: 'Project 2'));
    
    var issues = new List<Issue>()
      ..add(new Issue (title: 'Issue 1', projectName: 'Project 1'))
      ..add(new Issue (title: 'Issue 2', projectName: 'Project 2'))
      ..add(new Issue (title: 'Issue 3', projectName: 'Project 3'));
    
    var store = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(issues)
      ..when(callsTo('getAllProjects')).alwaysReturn(projects);
    
    IssueBoardService issueBoardService = new IssueBoardService(store);  
        
    // Act
    IssueBoard board = issueBoardService.getIssuesByProjectName('Project 1', null);    
        
    // Assert
    assert(board.issues.length == 1);
  });
  
  test('retrieving IssueBoard via getAllIssues limits results set based on page info', () {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var issues = new List<Issue>()
          ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')));
    
    var store = new StoreMock()
          ..when(callsTo('getAllIssues')).alwaysReturn(issues);

    IssueBoardService issueBoardService = new IssueBoardService(store);  
    
    // Act
    IssueBoard board = issueBoardService.getAllIssues(pageInfo);
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
  });
  
  test('retrieving IssueBoard via getIssuesByName limits results set based on page info', () {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var issues = new List<Issue>()
          ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')));
    
    var store = new StoreMock()
          ..when(callsTo('getAllIssues')).alwaysReturn(issues);

    IssueBoardService issueBoardService = new IssueBoardService(store);  
    
    // Act
    IssueBoard board = issueBoardService.getIssuesByName('Issue', pageInfo);
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
  });
  
  test('retrieving IssueBoard via getIssuesByprojectName limits results set based on page info', () {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var projects = new List<Project>()
          ..add(new Project(name: 'Project 1'));
   
    var issues = new List<Issue>()
         ..add(new Issue (title: 'Issue 1', projectName: 'Project 1'))
         ..add(new Issue (title: 'Issue 2', projectName: 'Project 1'))
         ..add(new Issue (title: 'Issue 3', projectName: 'Project 1'));
   
    var store = new StoreMock()
        ..when(callsTo('getAllIssues')).alwaysReturn(issues)
        ..when(callsTo('getAllProjects')).alwaysReturn(projects);
   
    IssueBoardService issueBoardService = new IssueBoardService(store);  
       
    // Act
    IssueBoard board = issueBoardService.getIssuesByProjectName('Project 1', pageInfo);
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
  });
  
  test('retrieving IssueBoard via getAllIssues limits results set to specified page size and sets paging metadata', () {
      // Arrange
      var pageInfo = new PageInfo(0, 2);
      var issues = new List<Issue>()
            ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
            ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
            ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')));
      
      var store = new StoreMock()
            ..when(callsTo('getAllIssues')).alwaysReturn(issues);

      IssueBoardService issueBoardService = new IssueBoardService(store);  
      
      // Act
      IssueBoard board = issueBoardService.getAllIssues(pageInfo);
      
      // Assert
      assert(board.pageInfo == pageInfo);
      assert(board.searchQueryMethod == #getAllIssues);
      expect(board.searchQueryArgs, orderedEquals([]));
    });
    
    test('retrieving IssueBoard via getIssuesByName limits results set to specified page size and sets paging metadata', () {
      // Arrange
      var pageInfo = new PageInfo(0, 2);
      String searchTerm = 'Issue';
      
      var issues = new List<Issue>()
            ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
            ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
            ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')));
      
      var store = new StoreMock()
            ..when(callsTo('getAllIssues')).alwaysReturn(issues);

      IssueBoardService issueBoardService = new IssueBoardService(store);  
      
      // Act
      IssueBoard board = issueBoardService.getIssuesByName(searchTerm, pageInfo);
      
      // Assert
      assert(board.pageInfo == pageInfo);
      assert(board.searchQueryMethod == #getIssuesByName);
      expect(board.searchQueryArgs, orderedEquals([searchTerm]));
    });
    
    test('retrieving IssueBoard via getIssuesByprojectName limits results set to specified page size and sets paging metadata', () {
      // Arrange
      var pageInfo = new PageInfo(0, 2);
      String projectName = 'Project 1';
      var projects = new List<Project>()
            ..add(new Project(name: 'Project 1'));
     
      var issues = new List<Issue>()
           ..add(new Issue (title: 'Issue 1', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 2', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 3', projectName: 'Project 1'));
     
      var store = new StoreMock()
          ..when(callsTo('getAllIssues')).alwaysReturn(issues)
          ..when(callsTo('getAllProjects')).alwaysReturn(projects);
     
      IssueBoardService issueBoardService = new IssueBoardService(store);  
         
      // Act
      IssueBoard board = issueBoardService.getIssuesByProjectName(projectName, pageInfo);
      
      // Assert
      assert(board.pageInfo == pageInfo);
      assert(board.searchQueryMethod == #getIssuesByProjectName);
      expect(board.searchQueryArgs, orderedEquals([projectName]));
    });
  
  test('calling GetNextPage on the IssueBoard service will retrieve the set of results limited to the specified page size', () {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var issues = new List<Issue>()
          ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')))
          ..add(new Issue (title: 'Issue 4', dueDate: DateTime.parse('2014-11-13 14:59:00')));
    
    var store = new StoreMock()
          ..when(callsTo('getAllIssues')).alwaysReturn(issues);

    IssueBoardService issueBoardService = new IssueBoardService(store);
    IssueBoard board = issueBoardService.getAllIssues(pageInfo);
    
    // Act
    IssueBoard nextPageBoard = issueBoardService.getNextPage(board); 
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
    assert(nextPageBoard.issues.length == pageInfo.pageSize);
    
    assert(board.issues[0].title == issues[0].title);
    assert(board.issues[1].title == issues[1].title);
    assert(nextPageBoard.issues[0].title == issues[2].title);
    assert(nextPageBoard.issues[1].title == issues[3].title);
    
  });
}

