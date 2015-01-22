import 'package:unittest/unittest.dart';
import "package:redis_client/redis_client.dart";
import 'dart:convert';

import '../lib/issuelib.dart';

void main() {
  
  group('Redis store integration tests', (){
    // db1 corresponds to test database
    const connectionString = 'localhost:6379/1';
    RedisClient client;
    
    setUp((){
      
      return RedisClient.connect(connectionString)
          .then((RedisClient c) {
              client = c;
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
    
  });
}