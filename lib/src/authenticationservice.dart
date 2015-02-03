part of issuelib;

class AuthenticationService {

    Store store;
    HashingManager hashingManager;

    AuthenticationService(this.store, this.hashingManager);

    Future createUser(User user) async {

        if (await this.store.hasUser(user.username)) throw new ArgumentError('Username already exists');

        user.passwordSalt = this.hashingManager.generateSalt();
        user.passwordHash = this.hashingManager.generateHash(user.plainTextPassword, user.passwordSalt);

        /// Do not store plain text password
        user.plainTextPassword = '';

        await this.store.storeUser(user);
    }

    Future<String> login(String username, String plainTextPassword) async {
        var user = await this.store.getUser(username);
        if (user == null) throw new ArgumentError("Could not find user in our system");

        var passwordHash = this.hashingManager.generateHash(plainTextPassword, user.passwordSalt);

        if (passwordHash != user.passwordHash) throw new ArgumentError("The password used to login did not match the password saved to the store.");

        var uuid = new Uuid();
        var sessionToken = uuid.v1();

        var userSession = new UserSession.create(sessionToken, username);
        this.store.storeUserSession(userSession);

        return sessionToken;
    }

    Future logout(String sessionToken) async {
        await this.store.deleteUserSession(sessionToken);
    }
}
