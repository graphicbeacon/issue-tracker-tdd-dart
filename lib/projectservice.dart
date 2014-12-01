part of issuelib;

class ProjectService {
  Store store;
    
  ProjectService(this.store);
  
  void createProject(String name, String description) {
    if (store.hasProject(name))
      throw new ArgumentError("Name must be unique");
    
    var project = new Project(
        name: name,
        description:description);
    
    store.storeProject(project);
  }
 
}