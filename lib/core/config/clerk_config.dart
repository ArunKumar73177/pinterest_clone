
/// ✓ CLERK_FLUTTER: Clerk authentication configuration
/// Contains publishable key and redirect URLs
class ClerkConfig {
  static const String publishableKey = 'pk_test_dGVhY2hpbmctc2F3Zmx5LTU1LmNsZXJrLmFjY291bnRzLmRldiQ';

  // Redirect URLs after authentication
  static const String signInRedirect = '/home';
  static const String signUpRedirect = '/home';
  static const String signOutRedirect = '/';

  // OAuth provider configurations
  static const List<String> oAuthProviders = [
    'oauth_google',
  ];
}