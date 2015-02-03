part of issuelib;

class ProjectService {
  Store store;
    
  ProjectService(this.store);
  
  Future createProject(String name, String description) async {
    if (await store.hasProject(name))
      throw new ArgumentError("Name must be unique");
    
    var project = new Project.create(name, description);
    
    await store.storeProject(project);
  }
 
}