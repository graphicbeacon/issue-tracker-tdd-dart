import 'package:unittest/unittest.dart';
import "package:redis_client/redis_client.dart";
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';


void main() {

  test('can create Project', () async {
    // Arrange
    var store = new StoreMock()
          ..when(callsTo('hasProject')).alwaysReturn(false);
    
    ProjectService projectService = new ProjectService(store);
    String name = 'Test Project';
    String description = 'This is a test';

    // Act
    await projectService.createProject(name, description);

    // Assert
    store.getLogs(callsTo('storeProject')).verify(happenedOnce);
  });

  test('can create project and set all properties', () async {
    // Arrange
    Project expectedProject = new Project(
        name : 'Test Project',
        description : 'This is a test'
    );

    var store = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(false);
    
    ProjectService projectService = new ProjectService(store);

    // Act
    await projectService.createProject(expectedProject.name, expectedProject.description);

    // Assert
    store.getLogs(callsTo('storeProject', expectedProject)).verify(happenedOnce);
  });

  test('will throw error if project name is not unique', () async {
    // Arrange
    var projects = new List<Project>()
        ..add(new Project(name: 'Project 1'));
    
    var store = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(true);
    
    ProjectService projectService = new ProjectService(store);
    String name = 'Project 1';

    // Act, Assert
    try {
      await projectService.createProject(name,'');
      assert(false); // Ensure that catch block gets hit
    } catch(e) {
      assert(e is ArgumentError);
    }
  });
  
}
