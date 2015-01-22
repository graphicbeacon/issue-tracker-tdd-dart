part of issuelib;

class ProjectService {
  Store store;
    
  ProjectService(this.store);
  
  Future createProject(String name, String description) async {
    if (await store.hasProject(name))
      throw new ArgumentError("Name must be unique");
    
    var project = new Project(
        name: name,
        description:description);
    
    await store.storeProject(project);
  }
 
}