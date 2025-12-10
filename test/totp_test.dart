import 'package:flutter_test/flutter_test.dart';
import 'package:ejemplo1_avansada/logica/logica_login.dart';
import 'package:otp/otp.dart';

void main() {
  group('AutenticacionLogin TOTP Tests', () {
    test('TOTP verification should work with correct code', () {
      // Create a user with TOTP secret
      final user = Usuario(
        username: 'testuser',
        password: 'testpass',
        totpSecret: 'NCQCGW276RXWI5AN',
      );

      // Generate a valid TOTP code
      final now = DateTime.now().millisecondsSinceEpoch;
      final validCode = OTP.generateTOTPCodeString(
        'NCQCGW276RXWI5AN',
        now,
        length: 6,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      // Create auth instance and simulate login
      final auth = AutenticacionLogin();
      auth.usuarios = [user];
      auth.currentUser = user;

      // Verify the generated code
      expect(auth.verifyTOTP(validCode), true);
    });

    test('TOTP verification should fail with incorrect code', () {
      // Create a user with TOTP secret
      final user = Usuario(
        username: 'testuser',
        password: 'testpass',
        totpSecret: 'NCQCGW276RXWI5AN',
      );

      // Create auth instance and simulate login
      final auth = AutenticacionLogin();
      auth.usuarios = [user];
      auth.currentUser = user;

      // Verify with an invalid code
      expect(auth.verifyTOTP('000000'), false);
    });

    test('TOTP should not be required for users without secret', () {
      // Create a user without TOTP secret
      final user = Usuario(
        username: 'testuser',
        password: 'testpass',
      );

      // Create auth instance and simulate login
      final auth = AutenticacionLogin();
      auth.usuarios = [user];
      auth.currentUser = user;

      // Check if TOTP is required
      expect(auth.requiresTOTP(), false);
      
      // Verify should pass even with any code when TOTP is not required
      expect(auth.verifyTOTP('123456'), true);
    });

    test('TOTP should be required for users with secret', () {
      // Create a user with TOTP secret
      final user = Usuario(
        username: 'testuser',
        password: 'testpass',
        totpSecret: 'NCQCGW276RXWI5AN',
      );

      // Create auth instance and simulate login
      final auth = AutenticacionLogin();
      auth.usuarios = [user];
      auth.currentUser = user;

      // Check if TOTP is required
      expect(auth.requiresTOTP(), true);
    });
  });
}
