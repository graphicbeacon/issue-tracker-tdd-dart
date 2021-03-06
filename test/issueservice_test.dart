import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {

    test('calling createIssue on IssueService stores issue', () async {

        // Arrange
        var user = new User.create('Bob', 'Doe', 'bob', '');
        var userSession = new UserSession.create('token', user.username);

        var issueStore = new StoreMock()
                ..when(callsTo('hasProject')).alwaysReturn(true)
                ..when(callsTo('hasIssue')).alwaysReturn(false)
                ..when(callsTo('getUserSession')).alwaysReturn(userSession)
                ..when(callsTo('getUser')).alwaysReturn(user);

        var issueService = new IssueService(issueStore, '');
        var id = '123';
        var title = '';
        var description = '';
        var dueDate = new DateTime.now();
        var issueStatus = new IssueStatus.opened();
        var projectName = '';

        // Act
        await issueService.createIssue(id, title, description, dueDate, issueStatus, projectName, '');

        // Assert
        issueStore.getLogs(callsTo('storeIssue')).verify(happenedOnce);
    });

    test('calling createIssue on IssueService stores issue with correct values', () async {

        // Arrange
        var user = new User.create('Bob', 'Doe', 'bob', '');
        var userSession = new UserSession.create('token', user.username);

        var expectedIssue = new Issue.create('123', 'Lorem ipsum dolor sit amet', 'This is the issue description.', new DateTime.now(), new IssueStatus.opened(), 'Project 1', 'Bob Doe', 'Bob Doe');

        var issueStore = new StoreMock()
                ..when(callsTo('hasProject')).alwaysReturn(true)
                ..when(callsTo('hasIssue')).alwaysReturn(false)
                ..when(callsTo('getUserSession')).alwaysReturn(userSession)
                ..when(callsTo('getUser')).alwaysReturn(user);

        var issueService = new IssueService(issueStore, '');

        // Act
        await issueService.createIssue(expectedIssue.id, expectedIssue.title, expectedIssue.description, expectedIssue.dueDate, expectedIssue.status, expectedIssue.projectName, '');

        // Assert
        issueStore.getLogs(callsTo('storeIssue', expectedIssue)).verify(happenedOnce);
    });

    test('calling createIssue on IssueService throws if the specified project name does not exist in store', () async {

        // Arrange
        var issueStore = new StoreMock()
                ..when(callsTo('hasIssue')).alwaysReturn(false)
                ..when(callsTo('hasProject')).alwaysReturn(false);

        var issueService = new IssueService(issueStore, '');

        var title = 'Lorem ipsum dolor sit amet';
        var description = 'This is the issue description.';
        var dueDate = new DateTime.now();
        var issueStatus = new IssueStatus.opened();
        var projectName = 'Project 1';

        // Act, Assert
        try {
            await issueService.createIssue('123', title, description, dueDate, issueStatus, projectName, '');
            assert(false); // Ensure that catch block gets hit
        } catch (e) {
            assert(e is ArgumentError);
        }
    });

    test('calling createIssue on IssueService takes in UserSession token and populates createdBy and assignedTo fields', () async {
        // Arrange
        var user = new User.create('Bob', 'Doe', 'bob', '');
        var userSession = new UserSession.create('token', user.username);

        var expectedIssue = new Issue.create('123', 'Lorem ipsum dolor sit amet', 'This is the issue description.', new DateTime.now(), new IssueStatus.opened(), 'Project 1', '${user.firstName} ${user.lastName}', '${user.firstName} ${user.lastName}');

        var issueStore = new StoreMock()
                ..when(callsTo('hasProject')).alwaysReturn(true)
                ..when(callsTo('hasIssue')).alwaysReturn(false)
                ..when(callsTo('getUserSession')).alwaysReturn(userSession)
                ..when(callsTo('getUser')).alwaysReturn(user);

        var issueService = new IssueService(issueStore, '');

        // Act
        await issueService.createIssue('123', expectedIssue.title, expectedIssue.description, expectedIssue.dueDate, expectedIssue.status, expectedIssue.projectName, userSession.sessionToken);

        // Assert
        issueStore.getLogs(callsTo('storeIssue', expectedIssue)).verify(happenedOnce);
    });

    test('calling createIssue on IssueService will throw an exception when the user is not signed in', () async {
        // Arrange
        var userSession = new UserSession.create('token', 'Bob');

        var issue = new Issue()
                ..id = '123'
                ..title = 'Lorem ipsum dolor sit amet'
                ..description = 'This is the issue description.'
                ..dueDate = new DateTime.now()
                ..status = new IssueStatus.opened()
                ..projectName = 'Project 1';

        var issueStore = new StoreMock()
                ..when(callsTo('hasProject')).alwaysReturn(true)
                ..when(callsTo('hasIssue')).alwaysReturn(false)
                ..when(callsTo('getUserSession')).alwaysReturn(null);

        var issueService = new IssueService(issueStore, '');

        // Act, Assert
        try {
            await issueService.createIssue(issue.id, issue.title, issue.description, issue.dueDate, issue.status, issue.projectName, userSession.sessionToken);
            assert(false); // Ensure that catch block gets hit
        } catch (e) {
            assert(e is ArgumentError);
        }

    });

    test('calling createIssue on IssueService will throw an exception when id already exists', () async {
        // Arrange
        var userSession = new UserSession.create('token', 'Bob');

        var issue = new Issue()
                ..id = '123'
                ..title = 'Lorem ipsum dolor sit amet'
                ..description = 'This is the issue description.'
                ..dueDate = new DateTime.now()
                ..status = new IssueStatus.opened()
                ..projectName = 'Project 1';

        var issueStore = new StoreMock()..when(callsTo('hasIssue')).alwaysReturn(true);

        var issueService = new IssueService(issueStore, '');

        // Act, Assert
        try {
            await issueService.createIssue(issue.id, issue.title, issue.description, issue.dueDate, issue.status, issue.projectName, userSession.sessionToken);
            assert(false); // Ensure that catch block gets hit
        } catch (e) {
            assert(e is ArgumentError);
        }
    });

    test('saving saveAttachment on IssueService will populate the attachment list on the issue object', () async {
        // Arrange
        const fileName = 'file';

        var issue = new Issue()
                ..id = '123'
                ..title = 'Lorem ipsum dolor sit amet'
                ..description = 'This is the issue description.'
                ..dueDate = new DateTime.now()
                ..status = new IssueStatus.opened()
                ..projectName = 'Project 1'
                ..attachments = new List<Attachment>();
        ;

        var issueStore = new StoreMock()
                ..when(callsTo('hasIssue')).alwaysReturn(true)
                ..when(callsTo('getIssue')).alwaysReturn(issue)
                ..when(callsTo('hasUserSession')).alwaysReturn(true);

        var issueService = new IssueService(issueStore, '');

        // Act
        await issueService.saveAttachment(issue.id, '', fileName);

        // Assert
        issueStore.getLogs(callsTo('getIssue')).verify(happenedOnce);
        issueStore.getLogs(callsTo('storeIssue')).verify(happenedOnce);

        assert(issue.attachments.length == 1);
        assert(issue.attachments[0].name == fileName);
    });

    test('saving saveAttachment on IssueService will throw error if issue id does not exist', () async {
        // Arrange
        var issueStore = new StoreMock()
                ..when(callsTo('getIssue')).alwaysReturn(null)
                ..when(callsTo('hasUserSession')).alwaysReturn(true);

        var issueService = new IssueService(issueStore, '');

        // Act, Assert
        try {
            await issueService.saveAttachment('123', '', 'file name');
            assert(false); // Ensure that catch block gets hit
        } catch (e) {
            assert(e is ArgumentError);
        }
    });

    test('saving saveAttachment on IssueService will throw error if user session does not exist', () async {
        // Arrange
        const sessionToken = 'token';
        var issueStore = new StoreMock()
                ..when(callsTo('getIssue')).alwaysReturn(new Issue())
                ..when(callsTo('hasUserSession')).alwaysReturn(false);

        var issueService = new IssueService(issueStore, '');

        // Act, Assert
        try {
            await issueService.saveAttachment('123', sessionToken, 'file name');
            assert(false); // Ensure that catch block gets hit
        } catch (e) {
            assert(e is ArgumentError);
        }

    });

    test('saving saveAttachment on IssueService will set file location on attachment', () async {
        // Arrange
        const fileName = 'file';
        const attachmentFilesDirectory = 'path/to/file';

        var issue = new Issue()
                ..id = '123'
                ..title = 'Lorem ipsum dolor sit amet'
                ..description = 'This is the issue description.'
                ..dueDate = new DateTime.now()
                ..status = new IssueStatus.opened()
                ..projectName = 'Project 1'
                ..attachments = new List<Attachment>();

        var issueStore = new StoreMock()
                ..when(callsTo('hasIssue')).alwaysReturn(true)
                ..when(callsTo('getIssue')).alwaysReturn(issue)
                ..when(callsTo('hasUserSession')).alwaysReturn(true);

        var issueService = new IssueService(issueStore, attachmentFilesDirectory);

        // Act
        await issueService.saveAttachment(issue.id, '', fileName);

        // Assert
        assert(issue.attachments.length == 1);
        assert(issue.attachments[0].location == '${attachmentFilesDirectory}/${issue.id}/${fileName}');
    });

//  test('calling saveAttachment on IssueService will create attachment file in specified location', () async {
//     // Arrange
//     var userSession = new UserSession('token', 'Bob');
//
//     // Act
//
//     // Assert
//  });
}
