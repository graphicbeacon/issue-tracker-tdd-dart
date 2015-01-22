part of issuelib;

class RedisStore implements Store {
  
  RedisClient client;
  
  RedisStore(RedisClient this.client);
  
  Future storeIssue (Issue issue) async {
    var key = 'issue:${issue.id}';
    
    await client.set(key, issue.toJson());
  }
}