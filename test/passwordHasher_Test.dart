//    String password = 'hello';
//    
//    List<int> saltBytes = new List<int>(); 
//    var random = new Random(new DateTime.now().millisecondsSinceEpoch);
//    for (var i = 0; i < 32; i++) {
//      saltBytes.add(random.nextInt(256));
//    }
//    
//    // Creating user
//    var passwordBytes = UTF8.encode(password);
//    
//    var hashedBytes = new SHA256()
//      ..add(passwordBytes)
//      ..add(saltBytes)
//      ..close();
//    
//    var saltString = CryptoUtils.bytesToBase64(saltBytes);
//    var hashString = CryptoUtils.bytesToBase64(hashedBytes);