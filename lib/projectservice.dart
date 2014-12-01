part of issuelib;

class ProjectService {
  Store store;
    
  ProjectService(this.store);
  
  void createProject(int id, String name, String description) {
    if (store.hasProject(id))
      throw new ArgumentError("Id must be unique");
    
    var project = new Project(
        id: id,
        name: name,
        description:description);
    
    store.storeProject(project);
  }
 
}