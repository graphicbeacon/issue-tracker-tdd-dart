import 'package:unittest/unittest.dart';
import "package:redis_client/redis_client.dart";
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';


void main() {

    test('can create Project', () async {
        // Arrange
        const name = 'Test Project';
        const description = 'This is a test';

        var store = new StoreMock()..when(callsTo('hasProject')).alwaysReturn(false);

        var projectService = new ProjectService(store);

        // Act
        await projectService.createProject(name, description);

        // Assert
        store.getLogs(callsTo('storeProject')).verify(happenedOnce);
    });

    test('can create project and set all properties', () async {
        // Arrange
        var expectedProject = new Project.create('Test Project', 'This is a test');

        var store = new StoreMock()..when(callsTo('hasProject')).alwaysReturn(false);

        var projectService = new ProjectService(store);

        // Act
        await projectService.createProject(expectedProject.name, expectedProject.description);

        // Assert
        store.getLogs(callsTo('storeProject', expectedProject)).verify(happenedOnce);
    });

    test('will throw error if project name is not unique', () async {
        // Arrange
        const name = 'Project 1';

        var projects = new List<Project>()..add(new Project.create('Project 1', 'This is a test'));

        var store = new StoreMock()..when(callsTo('hasProject')).alwaysReturn(true);

        var projectService = new ProjectService(store);

        // Act, Assert
        try {
            await projectService.createProject(name, '');
            assert(false); // Ensure that catch block gets hit
        } catch (e) {
            assert(e is ArgumentError);
        }
    });

}
