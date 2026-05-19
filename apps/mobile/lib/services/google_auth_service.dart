import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/core/config.dart';
import 'package:mobile/features/auth/constants/auth.dart';
import 'package:mobile/utils/error.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn;

  GoogleAuthService({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize(
      clientId: AppConfig.googleClientId,
      serverClientId: AppConfig.googleServerClientId,
    );
  }

  Future<String> getIdToken() async {
    if (!_googleSignIn.supportsAuthenticate()) {
      throw const AuthException(AuthConstants.googleSignInUnavailable);
    }

    try {
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthException(AuthConstants.googleIdTokenMissing);
      }

      return idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(AuthConstants.googleSignInCancelled);
      }

      throw AuthException(
        error.description ?? AuthConstants.googleSignInUnavailable,
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
