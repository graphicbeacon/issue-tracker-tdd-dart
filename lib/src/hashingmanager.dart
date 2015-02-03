part of issuelib;

abstract class HashingManager {
    /// Returns a random salt as a base64 string.
    String generateSalt();

    /// Returns a random hash as a base64 string.
    String generateHash(String password, String base64Salt);
}