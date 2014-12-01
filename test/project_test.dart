import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import '../lib/issuelib.dart';
import 'mocks.dart';


void main() {

  test('can create Project', () {
    // Arrange
    var store = new StoreMock()
          ..when(callsTo('hasProject')).alwaysReturn(false);
    
    ProjectService projectService = new ProjectService(store);
    int id = 0;
    String name = 'Test Project';
    String description = 'This is a test';

    // Act
    projectService.createProject(id, name, description);

    // Assert
    store.getLogs(callsTo('storeProject')).verify(happenedOnce);
  });

  test('can create project and set all properties', () {
    // Arrange
    Project expectedProject = new Project(
        id : 0,
        name : 'Test Project',
        description : 'This is a test'
    );

    var store = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(false);
    
    ProjectService projectService = new ProjectService(store);

    // Act
    projectService.createProject(expectedProject.id, expectedProject.name, expectedProject.description);

    // Assert
    store.getLogs(callsTo('storeProject', expectedProject)).verify(happenedOnce);
  });

  test('will throw error if project Id is not unique', () {
    // Arrange
    var store = new StoreMock()
        ..when(callsTo('hasProject')).alwaysReturn(true);
    
    ProjectService projectService = new ProjectService(store);
    int id = 1;
    String name = 'Test Project';
    String description = 'This is a test';

    // Act, Assert
    expect(() => projectService.createProject(id, name, description), throwsArgumentError);
  });


}
