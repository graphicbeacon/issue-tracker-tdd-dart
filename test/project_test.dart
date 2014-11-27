import 'package:unittest/unittest.dart';
import 'package:dartmocks/dartmocks.dart';

import '../lib/issuelib.dart';

void main() {

  test('can create Project', () {
    // Arrange
    var store = mock('Store')
        ..stub('getAllProjects').andReturn(new List<Project>())
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
        ..stub('getAllProjects').andReturn(new List<Project>())
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
    var projects = new List<Project>()..add(new Project(id: 1));

    var store = stub('Store')
        ..stub('storeProject').andReturn(null)
        ..stub('getAllProjects').andReturn(projects);

    ProjectService projectService = new ProjectService(store);
    int id = 1;
    String name = 'Test Project';
    String description = 'This is a test';

    // Act, Assert
    expect(() => projectService.createProject(id, name, description), throwsArgumentError);
  });


}
