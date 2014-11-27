part of issuelib;

class ProjectService {
  var store;
    
  ProjectService(this.store);
  
  void createProject(int id, String name, String description) {
    var idExists = store.getAllProjects()
        .any((Project project) => project.id == id);
    
    if (idExists == true)
      throw new ArgumentError("Id must be unique");
    
    var project = new Project(
        id: id,
        name: name,
        description:description);
    
    store.storeProject(project);
  }
}