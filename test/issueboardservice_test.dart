import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {
  
  // IssueBoardService tests
  test('calling getAllIssues on issueBoardService returns all issues as an IssueBoard', () async {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var issues = new List<Issue>()
      ..add(new Issue (dueDate: new DateTime.now()))
      ..add(new Issue (dueDate: new DateTime.now()));
      
    var issueStore = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(issues);
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
    
    // Act
    IssueBoard board = await issueBoardService.getAllIssues(pageInfo);
    
    // Assert
    assert(board.issues != null);
    assert(board.issues.length == issues.length);
  });
  
  test('calling getAllIssues on issueBoardService returns all issues as an IssueBoard ordered by dueDate descending.', () async {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var issues = new List<Issue>()
      ..add(new Issue (dueDate: DateTime.parse('2014-11-13 14:59:00')))
      ..add(new Issue (dueDate: DateTime.parse('2014-11-13 17:59:00')));
      
    var issueStore = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(new List<Issue>.from(issues));
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
    
    // Act
    IssueBoard board = await issueBoardService.getAllIssues(pageInfo);
    
    // Assert
    assert(board.issues.length == issues.length);
    assert(board.issues[0].dueDate.isAtSameMomentAs(issues[1].dueDate));
    assert(board.issues[1].dueDate.isAtSameMomentAs(issues[0].dueDate));
  });
  
  test('calling getIssueByName on IssueBoardService returns all issues as an IssueBoard with name', () async {
    
    // Arrange
    var pageInfo = new PageInfo(0, 2);
    var issues = new List<Issue>()
      ..add(new Issue (title: 'Create blah'))
      ..add(new Issue (title: 'Create blah feature'))
      ..add(new Issue (title: 'Delete pingdom alerts'));
          
    var issueStore = new StoreMock()
      ..when(callsTo('getAllIssues')).alwaysReturn(new List<Issue>.from(issues));
    
    IssueBoardService issueBoardService = new IssueBoardService(issueStore);
        
    // Act
    IssueBoard board = await issueBoardService.getIssuesByName('Create', pageInfo);
    
    // Assert
    assert(board.issues.length == 2);
  });
  
  test('calling getIssuesByProjectName on IssueBoardService returns all issues filtered by project name', () async {
    // Arrange
    var pageInfo = new PageInfo(0, 2);
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
    IssueBoard board = await issueBoardService.getIssuesByProjectName('Project 1', pageInfo);    
        
    // Assert
    assert(board.issues.length == 1);
  });
  
  test('retrieving IssueBoard via getAllIssues limits results set based on page info', () async {
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
    IssueBoard board = await issueBoardService.getAllIssues(pageInfo);
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
  });
  
  test('retrieving IssueBoard via getIssuesByName limits results set based on page info', () async {
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
    IssueBoard board = await issueBoardService.getIssuesByName('Issue', pageInfo);
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
  });
  
  test('retrieving IssueBoard via getIssuesByprojectName limits results set based on page info', () async {
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
   
    var issueBoardService = new IssueBoardService(store);  
       
    // Act
    var board = await issueBoardService.getIssuesByProjectName('Project 1', pageInfo);
    
    // Assert
    assert(board.issues.length == pageInfo.pageSize);
  });
  
  test('retrieving IssueBoard via getAllIssues sets paging metadata', () async {
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
      IssueBoard board = await issueBoardService.getAllIssues(pageInfo);
      
      // Assert
      assert(board.pageInfo == pageInfo);
      assert(board.searchQueryMethod == #getAllIssues);
      expect(board.searchQueryArgs, orderedEquals([]));
    });
    
    test('retrieving IssueBoard via getIssuesByName sets paging metadata', () async {
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
      IssueBoard board = await issueBoardService.getIssuesByName(searchTerm, pageInfo);
      
      // Assert
      assert(board.pageInfo == pageInfo);
      assert(board.searchQueryMethod == #getIssuesByName);
      expect(board.searchQueryArgs, orderedEquals([searchTerm]));
    });
    
    test('retrieving IssueBoard via getIssuesByprojectName sets paging metadata', () async {
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
      IssueBoard board = await issueBoardService.getIssuesByProjectName(projectName, pageInfo);
      
      // Assert
      assert(board.pageInfo == pageInfo);
      assert(board.searchQueryMethod == #getIssuesByProjectName);
      expect(board.searchQueryArgs, orderedEquals([projectName]));
    });


  test('retrieving IssueBoard via getAllIssues skip results based on skip count', () async {
        // Arrange
        var pageInfo = new PageInfo(4, 2);
        var issues = new List<Issue>()
              ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 4', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 5', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 6', dueDate: DateTime.parse('2014-11-13 14:59:00')));
        
        var store = new StoreMock()
              ..when(callsTo('getAllIssues')).alwaysReturn(issues);

        IssueBoardService issueBoardService = new IssueBoardService(store);  
        
        // Act
        IssueBoard board = await issueBoardService.getAllIssues(pageInfo);
        
        // Assert
        assert(board.issues.length == 2);
        assert(board.issues[0] == issues[4]);
        assert(board.issues[1] == issues[5]);
      });
  
  test('calling getAllIssues on the IssueBoardService with no pageInfo will throw ArgumentError', () async{
    // Act, Assert
    try {
      await new IssueBoardService(null).getAllIssues(null);
      assert(false); // Ensure that catch block gets hit
    } catch (e) {
      assert(e is ArgumentError);
    }
  });
  
  test('calling getIssuesByName on the IssueBoardService with no pageInfo will throw ArgumentError', () async {
    // Act, Assert
    try {
      await new IssueBoardService(null).getIssuesByName(null, null);
      assert(false); // Ensure that catch block gets hit
    } catch (e) {
      assert(e is ArgumentError);
    }
  });
  
  test('calling getIssuesByProjectName on the IssueBoardService with no pageInfo will throw ArgumentError', () async {
    // Act, Assert
    try {
      await new IssueBoardService(null).getIssuesByProjectName(null, null);
      assert(false); // Ensure that catch block gets hit
    } catch (e) {
      assert(e is ArgumentError);
    }
  });
  
  test('retrieving IssueBoard via getIssuesByName skip results based on skip count', () async {
        // Arrange
        var pageInfo = new PageInfo(4, 2);
        String searchTerm = 'Issue';
        
        var issues = new List<Issue>()
              ..add(new Issue (title: 'Issue 1', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 2', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 3', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 4', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 5', dueDate: DateTime.parse('2014-11-13 14:59:00')))
              ..add(new Issue (title: 'Issue 6', dueDate: DateTime.parse('2014-11-13 14:59:00')));
        
        var store = new StoreMock()
              ..when(callsTo('getAllIssues')).alwaysReturn(issues);

        IssueBoardService issueBoardService = new IssueBoardService(store);  
        
        // Act
        IssueBoard board = await issueBoardService.getIssuesByName(searchTerm, pageInfo);
        
        // Assert
        assert(board.issues.length == 2);
        assert(board.issues[0] == issues[4]);
        assert(board.issues[1] == issues[5]);
      });
  

    test('retrieving IssueBoard via getIssuesByprojectName sets paging metadata', () async {
      // Arrange
      var pageInfo = new PageInfo(4, 2);
      String projectName = 'Project 1';
      var projects = new List<Project>()
            ..add(new Project(name: 'Project 1'));
     
      var issues = new List<Issue>()
           ..add(new Issue (title: 'Issue 1', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 2', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 3', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 4', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 5', projectName: 'Project 1'))
           ..add(new Issue (title: 'Issue 6', projectName: 'Project 1'));
     
      var store = new StoreMock()
          ..when(callsTo('getAllIssues')).alwaysReturn(issues)
          ..when(callsTo('getAllProjects')).alwaysReturn(projects);
     
      IssueBoardService issueBoardService = new IssueBoardService(store);  
         
      // Act
      IssueBoard board = await issueBoardService.getIssuesByProjectName(projectName, pageInfo);
      
      // Assert
      assert(board.issues.length == 2);
      assert(board.issues[0] == issues[4]);
      assert(board.issues[1] == issues[5]);
    });
}

  
