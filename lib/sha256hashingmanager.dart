part of issuelib;
class Sha256HashingManager implements HashingManager {
  
  @override
  String generateHash(String password, String salt) {
    var passwordBytes = UTF8.encode(password);
    var saltBytes = CryptoUtils.base64StringToBytes(salt);
    
    var hasher = new SHA256()
      ..add(passwordBytes)
      ..add(saltBytes);
    
    var hashedBytes = hasher.close();
    
    return CryptoUtils.bytesToBase64(hashedBytes);
  }

  @override
  String generateSalt() {
    StringBuffer saltStringBuffer = new StringBuffer();
    
    var random = new Random(new DateTime.now().millisecondsSinceEpoch);
    for (var i = 0; i < 32; i++) {
      saltStringBuffer.write(random.nextInt(9).toString());
    }
    
    var saltStringBytes = UTF8.encode(saltStringBuffer.toString());
    
    return CryptoUtils.bytesToBase64(saltStringBytes);
  }
}
