import 'package:unittest/unittest.dart';
import '../lib/issuelib.dart';

void main() {

    test('calling generateSalt will produce a completely random salt', () {
        // Arrange

        // 32 random ints will be UTF8 and base64 encoded. The length should be 44 characters.
        const expectedLength = 44;
        var hashingManager = new Sha256HashingManager();

        // Act
        var salt = hashingManager.generateSalt();

        // Assert
        assert(salt != null && salt.isNotEmpty);
        assert(salt.length == expectedLength);
    });

    test('calling generateHash will produce a valid sha256 hash for the given password', () {
        // Arrange
        const base64Salt = 'MTg4NTEzNDA4NDIzMTU4MTAwODM4NzQ0ODExMjIwNTU=';
        const password = 'hello';

        const expectedBase64Hash = 'iakwup+nq9JFezpvpFskA4tmmVcbEViCVMuSttOW7jg=';

        var hashingManager = new Sha256HashingManager();

        // Act
        var hash = hashingManager.generateHash(password, base64Salt);

        // Assert
        assert(hash == expectedBase64Hash);
    });

}
