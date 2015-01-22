import 'package:unittest/unittest.dart';
import "package:redis_client/redis_client.dart";

import '../lib/issuelib.dart';

void main() {
  
  group('Redis store integration tests', (){
    // db1 corresponds to test database
    const connectionString = 'localhost:6379';
    RedisClient client;
    
    setUp((){
      
      return RedisClient.connect(connectionString)
          .then((RedisClient c) {
              client = c;  
              client.select(1);
          });
      
    });
    
    tearDown(() {
      
      return client.flushdb()
            .then((c) => client.close())
            .then((c) => client = null); 
     
    });
    
    test('serialise and store Issue object with correct key', () async {
      // Arrange
      var issue = new Issue(
          id: '123', 
          title: 'Issue 1', 
          description: 'Issue description', 
          dueDate: new DateTime.now(), 
          status: new IssueStatus.opened(), 
          projectName: 'Project 1', 
          createdBy: 'Bob', 
          assignedTo: 'Bob'
      );
      var expectedRedisKey = 'issue:${issue.id}';
      
      RedisStore redisStore = new RedisStore(client);
      
      // Act
      await redisStore.storeIssue(issue);
      
      //Assert 
      return client.get(expectedRedisKey).then((String object) {
        Issue retrievedIssue = new Issue()..initFromJson(object);
        
        assert(issue == retrievedIssue);
      });
      
    });
    
    test('serialise and store Project object with correct key', () async {
      // Arrange
      var project = new Project(
          name : 'Test Project',
          description : 'This is a test'
      );
      var expectedRedisKey = 'project:${project.name}';
      
      RedisStore redisStore = new RedisStore(client);
      
      // Act
      await redisStore.storeProject(project);
      
      //Assert 
      return client.get(expectedRedisKey).then((String object) {
        Project retrievedProject = new Project()..initFromJson(object);
        
        assert(project == retrievedProject);
      });
      
    });
    
    test('serialise and store User object with correct key', () async {
      // Arrange
      var user = new User('firstName', 'lastName', 'username', 'plainTextPassword');
      var expectedRedisKey = 'user:${user.username}';
      
      RedisStore redisStore = new RedisStore(client);
      
      // Act
      await redisStore.storeUser(user);
      
      //Assert 
      return client.get(expectedRedisKey).then((String object) {
        User retrievedUser = new User('','','','')..initFromJson(object);
        
        assert(user == retrievedUser);
      });
      
    });
    
    test('serialise and store UserSession object with correct key', () async {
      // Arrange
      var userSession = new UserSession('sessionToken', 'username');
      var expectedRedisKey = 'usersession:${userSession.sessionToken}';
      
      RedisStore redisStore = new RedisStore(client);
      
      // Act
      await redisStore.storeUserSession(userSession);
      
      //Assert 
      return client.get(expectedRedisKey).then((String object) {
        UserSession retrievedUserSession = new UserSession('','')..initFromJson(object);
        
        assert(userSession == retrievedUserSession);
      });
      
    });
    
    test('delete UserSession object with correct key', () async {
      // Arrange
      var userSession = new UserSession('sessionToken', 'username');
      var expectedRedisKey = 'usersession:${userSession.sessionToken}';
      
      RedisStore redisStore = new RedisStore(client);
      await redisStore.storeUserSession(userSession);
      
      // Act
      await redisStore.deleteUserSession(userSession.sessionToken);
      
      //Assert 
      return client.exists(expectedRedisKey).then((bool doesExist) {
          assert(doesExist == false);
      });
      
    });
    
    test('retrieves all Issue objects stored in the db ordered by issue id', () async {
      // Arrange
      const numberOfIssues = 5;
      var issues = new List<Issue>();
      
      var redisStore = new RedisStore(client);
      
      for(var i = 0; i < numberOfIssues; i++) {
        var issue = new Issue(
            id: '$i', 
            title: 'Issue $i', 
            description: 'Issue description', 
            dueDate: new DateTime.now(), 
            status: new IssueStatus.opened(), 
            projectName: 'Project', 
            createdBy: 'Bob', 
            assignedTo: 'Bob'
        );
        
        await redisStore.storeIssue(issue);
        issues.add(issue);
      };
      
      // Act
      var retrievedIssues = await redisStore.getAllIssues();
      
      // Assert
      assert(retrievedIssues.length == numberOfIssues);
      
      for(var i = 0; i < numberOfIssues; i++) {
        assert(issues[i] == retrievedIssues[i]);
      };
    });
    
    test('retrieves all Project objects stored in the db ordered by name', () async {
      // Arrange
      const numberOfProjects = 3;
      var projects = new List<Project>();

      var redisStore = new RedisStore(client);

      for(var i = 0; i < numberOfProjects; i++) {
        var project = new Project(
           name: 'Project $i', 
           description: 'Project Description $i'
        );
  
        await redisStore.storeProject(project);
        projects.add(project);
      };

      // Act
      var retrievedProjects = await redisStore.getAllProjects();

      // Assert
      assert(retrievedProjects.length == numberOfProjects);

      for(var i = 0; i < numberOfProjects; i++) {
        assert(projects[i] == retrievedProjects[i]);
      };
    });
    
    test('retrieves Issue object stored in the db given an id', () async {
      // Arrange
      var issue = new Issue(
                  id: 'guid', 
                  title: 'Issue', 
                  description: 'Issue description', 
                  dueDate: new DateTime.now(), 
                  status: new IssueStatus.opened(), 
                  projectName: 'Project', 
                  createdBy: 'Bob', 
                  assignedTo: 'Bob'
              );
      
      var redisStore = new RedisStore(client);
      
      await redisStore.storeIssue(issue);

      // Act
      var retrievedIssue = await redisStore.getIssue(issue.id);

      // Assert
      assert(retrievedIssue == issue);
    });
    
    test('retrieves User object stored in the db given a username', () async {
      // Arrange
      var user = new User('firstName', 'lastName', 'username', 'plainTextPassword');
      
      var redisStore = new RedisStore(client);
      
      await redisStore.storeUser(user);

      // Act
      var retrievedUser = await redisStore.getUser(user.username);

      // Assert
      assert(retrievedUser == user);
    });
    
    test('retrieves UserSession object stored in the db given a sessionToken', () async {
      // Arrange
      var userSession = new UserSession('sessionToken', 'username');
      
      var redisStore = new RedisStore(client);
      
      await redisStore.storeUserSession(userSession);

      // Act
      var retrievedUserSession = await redisStore.getUserSession(userSession.sessionToken);

      // Assert
      assert(retrievedUserSession == userSession);
    });
    
    test('returns true if Issue object exists', () async {
      // Arrange
      var issue = new Issue(
                  id: 'guid', 
                  title: 'Issue', 
                  description: 'Issue description', 
                  dueDate: new DateTime.now(), 
                  status: new IssueStatus.opened(), 
                  projectName: 'Project', 
                  createdBy: 'Bob', 
                  assignedTo: 'Bob'
              );
      var expectedRedisKey = 'issue:${issue.id}';
      var redisStore = new RedisStore(client);

      await redisStore.storeIssue(issue);
      
      // Act
      var hasIssue = await redisStore.hasIssue(issue.id);
      
      // Assert
      assert(hasIssue == true);
    });
    
    test('returns true if Project object exists', () async {
      // Arrange
      var project = new Project(
          name: 'Project 1',
          description: 'Project description'
      );
      
      var expectedRedisKey = 'project:${project.name}';
      var redisStore = new RedisStore(client);
      
      await redisStore.storeProject(project);

      // Act
      var hasProject = await redisStore.hasProject(project.name);
      
      // Assert
      assert(hasProject == true);
    });
    
    test('returns true if User object exists', () async {
      // Arrange
      var user = new User('firstName', 'lastName', 'username', 'plainTextPassword');
      
      var expectedRedisKey = 'user:${user.username}';
      var redisStore = new RedisStore(client);

      await redisStore.storeUser(user);
      
      // Act
      var hasUser = await redisStore.hasUser(user.username);
      
      // Assert
      assert(hasUser == true);
    });
    
    test('returns true if User object exists', () async {
      // Arrange
      var userSession = new UserSession('sessionToken', 'username');
      
      var expectedRedisKey = 'usersession:${userSession.sessionToken}';
      var redisStore = new RedisStore(client);

      await redisStore.storeUserSession(userSession);
      
      // Act
      var hasUserSession = await redisStore.hasUserSession(userSession.sessionToken);
      
      // Assert
      assert(hasUserSession == true);
    });
  });
}