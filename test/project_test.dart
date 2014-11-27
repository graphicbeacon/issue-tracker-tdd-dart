import 'package:unittest/unittest.dart';
import 'package:dartmocks/dartmocks.dart';

import '../lib/issuelib.dart';

void main() {

  test('can create Project', () {
    // Arrange
    var store = mock('Store')
        ..stub('hasProject').andReturn(false)
        ..shouldReceive('storeProject');

    ProjectService projectService = new ProjectService(store);
    int id = 0;
    String name = 'Test Project';
    String description = 'This is a test';

    // Act
    projectService.createProject(id, name, description);

    // Assert
    store.verify();
  });

  test('can create project and set all properties', () {
    // Arrange
    Project project = null;

    var store = stub('Store')
        ..stub('hasProject').andReturn(false)
        ..stub('storeProject').andCall((receivedProject) => project = receivedProject);

    ProjectService projectService = new ProjectService(store);
    int id = 0;
    String name = 'Test Project';
    String description = 'This is a test';

    // Act
    projectService.createProject(id, name, description);

    // Assert
    assert(project != null);
    assert(project.id == id);
    assert(project.name == name);
    assert(project.description == description);
  });

  test('will throw error if project Id is not unique', () {
    // Arrange
    var store = stub('Store')
        ..stub('storeProject').andReturn(null)
        ..stub('hasProject').andReturn(true);

    ProjectService projectService = new ProjectService(store);
    int id = 1;
    String name = 'Test Project';
    String description = 'This is a test';

    // Act, Assert
    expect(() => projectService.createProject(id, name, description), throwsArgumentError);
  });


}
