part of issuelib;

class RedisStore implements Store {

    RedisClient client;

    RedisStore(RedisClient this.client);

    Future storeIssue(Issue issue) async {
        var key = 'issue:${issue.id}';

        await client.set(key, issue.toJson());
    }

    Future storeProject(Project project) async {
        var key = 'project:${project.name}';

        await client.set(key, project.toJson());
    }

    Future storeUser(User user) async {
        var key = 'user:${user.username}';

        await client.set(key, user.toJson());
    }

    Future storeUserSession(UserSession userSession) async {
        var key = 'usersession:${userSession.sessionToken}';

        await client.set(key, userSession.toJson());
    }

    Future deleteUserSession(String sessionToken) async {
        var key = 'usersession:$sessionToken';

        await client.del(key);
    }

    Future<List<Issue>> getAllIssues() async {
        var keySearchPattern = 'issue:*';

        var keys = await client.keys(keySearchPattern) as List<String>;

        if (keys.length == 0) return new List<Issue>();

        var issues = new List<Issue>();
        for (var key in keys) {
            var issueJson = await client.get(key) as String;
            issues.add(new Issue()..initFromJson(issueJson));
        }

        issues.sort((x, y) => x.id.compareTo(y.id));

        return issues;
    }

    Future<List<Project>> getAllProjects() async {
        var keySearchPattern = 'project:*';

        var keys = await client.keys(keySearchPattern) as List<String>;

        if (keys.length == 0) return new List<Issue>();

        var projects = new List<Project>();
        for (var key in keys) {
            var projectJson = await client.get(key) as String;
            projects.add(new Project()..initFromJson(projectJson));
        }

        projects.sort((x, y) => x.name.compareTo(y.name));

        return projects;
    }

    Future<Issue> getIssue(String id) async {
        var key = 'issue:$id';
        var json = await client.get(key);
        return new Issue()..initFromJson(json);
    }

    Future<User> getUser(String username) async {
        var key = 'user:$username';
        var json = await client.get(key);
        return new User()..initFromJson(json);
    }

    Future<UserSession> getUserSession(String sessionToken) async {
        var key = 'usersession:$sessionToken';
        var json = await client.get(key);
        return new UserSession()..initFromJson(json);
    }

    Future<bool> hasIssue(String id) async {
        var key = 'issue:$id';

        return client.exists(key);
    }

    Future<bool> hasProject(String projectName) async {
        var key = 'project:$projectName';

        return client.exists(key);
    }

    Future<bool> hasUser(String username) async {
        var key = 'user:$username';

        return client.exists(key);
    }

    Future<bool> hasUserSession(String sessionToken) async {
        var key = 'usersession:$sessionToken';

        return client.exists(key);
    }
}
