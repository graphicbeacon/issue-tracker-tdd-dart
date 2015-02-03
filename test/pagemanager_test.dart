import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';

void main() {

    test('calling getNextPage on the IssueBoard service will retrieve the next set of results limited to the specified page size and sets skipCount', () async {
        // Arrange
        var pageInfo = new PageInfo.create(0, 2);
        var issues = new List<Issue>()
                ..add(new Issue()
                        ..title = 'Issue 1'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 2'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 3'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 4'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'));

        var store = new StoreMock()..when(callsTo('getAllIssues')).alwaysReturn(issues);

        var issueBoardService = new IssueBoardService(store);
        var pageManager = new PageManager(issueBoardService);
        var board = await issueBoardService.getAllIssues(pageInfo);

        // Act
        var nextPageBoard = await pageManager.getNextPage(board);

        // Assert
        assert(nextPageBoard.issues.length == pageInfo.pageSize);
        assert(nextPageBoard.pageInfo.skipCount == 2);

        assert(board.issues[0] == issues[0]);
        assert(board.issues[1] == issues[1]);
        assert(nextPageBoard.issues[0] == issues[2]);
        assert(nextPageBoard.issues[1] == issues[3]);

    });

    test('calling getPreviousPage on the IssueBoard service will retrieve the previous set of results limited to the specified page size', () async {
        // Arrange
        var pageInfo = new PageInfo.create(0, 2);
        var issues = new List<Issue>()
                ..add(new Issue()
                        ..title = 'Issue 1'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 2'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 3'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 4'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'));

        var store = new StoreMock()..when(callsTo('getAllIssues')).alwaysReturn(issues);

        var issueBoardService = new IssueBoardService(store);
        var pageManager = new PageManager(issueBoardService);
        var initialBoard = await issueBoardService.getAllIssues(pageInfo);
        var nextPageBoard = await pageManager.getNextPage(initialBoard);

        // Act
        var previousPageBoard = await pageManager.getPreviousPage(nextPageBoard);

        // Assert
        assert(previousPageBoard.issues.length == pageInfo.pageSize);
        assert(previousPageBoard.pageInfo.skipCount == 0);

        assert(initialBoard.issues[0] == previousPageBoard.issues[0]);
        assert(initialBoard.issues[1] == previousPageBoard.issues[1]);
    });

    test('calling getPreviousPage on the IssueBoard service multiple times will never let skip count be less than zero', () async {

        var pageInfo = new PageInfo.create(0, 2);
        var issues = new List<Issue>()
                ..add(new Issue()
                        ..title = 'Issue 1'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'))
                ..add(new Issue()
                        ..title = 'Issue 2'
                        ..dueDate = DateTime.parse('2014-11-13 14:59:00'));

        var store = new StoreMock()..when(callsTo('getAllIssues')).alwaysReturn(issues);

        var issueBoardService = new IssueBoardService(store);
        var pageManager = new PageManager(issueBoardService);
        var board = await issueBoardService.getAllIssues(pageInfo);

        // Act
        var previousPageBoard = await pageManager.getPreviousPage(board);

        // Assert
        assert(board.issues[0] == previousPageBoard.issues[0]);
        assert(board.issues[1] == previousPageBoard.issues[1]);
    });
}
