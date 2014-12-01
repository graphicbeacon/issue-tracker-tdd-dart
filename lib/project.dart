part of issuelib;

class Project {
  String name;
  String description;
  
  Project({String this.name, String this.description});
  
  bool operator ==(o) {
      return o is Project &&
          name == o.name &&
          description == o.description;  
    }
}