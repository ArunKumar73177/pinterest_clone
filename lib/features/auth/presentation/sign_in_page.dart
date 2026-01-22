import 'package:flutter/material.dart';

/// Pinterest-style login screen shown after user enters email
/// Features password input with visibility toggle and Google sign-in option
class SignInPage extends StatefulWidget {
  final String email;

  const SignInPage({
    super.key,
    this.email = 'user@example.com', // Default email for demo
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Handle login action
    debugPrint('Login attempted with email: ${widget.email}');
  }

  void _handleGoogleLogin() {
    // Handle Google sign-in
    debugPrint('Continue with Google');
  }

  void _handleClose() {
    // Navigate back
    Navigator.of(context).pop();
  }

  void _handleForgotPassword() {
    // Handle forgot password
    debugPrint('Forgotten password clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Close button (top-left aligned)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: _handleClose,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: const EdgeInsets.all(8),
                        splashRadius: 24,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          hoverColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title - "Log in"
                    const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Continue with Google Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleGoogleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1e1e1e),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Icon
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CustomPaint(
                                painter: _GoogleIconPainter(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider with "OR"
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Email Display (readonly)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1e1e1e),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Password Input with visibility toggle
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 15,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1e1e1e),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white.withOpacity(0.6),
                            size: 20,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Log in Button - Pinterest red
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFe60023),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Forgotten password link
                    TextButton(
                      onPressed: _handleForgotPassword,
                      child: Text(
                        'Forgotten password?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for Google's multicolor G icon
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue section (top right)
    paint.color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(size.width * 0.98, size.height * 0.51)
      ..lineTo(size.width * 0.98, size.height * 0.41)
      ..lineTo(size.width * 0.5, size.height * 0.41)
      ..lineTo(size.width * 0.5, size.height * 0.59)
      ..lineTo(size.width * 0.77, size.height * 0.59)
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.68,
        size.width * 0.67,
        size.height * 0.8,
        size.width * 0.5,
        size.height * 0.8,
      );
    canvas.drawPath(bluePath, paint);

    // Green section (bottom right)
    paint.color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..cubicTo(
        size.width * 0.67,
        size.height,
        size.width * 0.8,
        size.height * 0.91,
        size.width * 0.87,
        size.height * 0.78,
      )
      ..lineTo(size.width * 0.74, size.height * 0.68)
      ..cubicTo(
        size.width * 0.69,
        size.height * 0.76,
        size.width * 0.6,
        size.height * 0.8,
        size.width * 0.5,
        size.height * 0.8,
      )
      ..close();
    canvas.drawPath(greenPath, paint);

    // Yellow section (bottom left)
    paint.color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.61)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.57,
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.43,
        size.width * 0.22,
        size.height * 0.39,
        size.width * 0.26,
        size.height * 0.36,
      )
      ..lineTo(size.width * 0.05, size.height * 0.22)
      ..cubicTo(
        size.width * 0.0,
        size.height * 0.3,
        size.width * 0.0,
        size.height * 0.42,
        size.width * 0.0,
        size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.0,
        size.height * 0.58,
        size.width * 0.02,
        size.height * 0.68,
        size.width * 0.05,
        size.height * 0.73,
      )
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Red section (top left)
    paint.color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.2)
      ..cubicTo(
        size.width * 0.63,
        size.height * 0.2,
        size.width * 0.72,
        size.height * 0.24,
        size.width * 0.79,
        size.height * 0.31,
      )
      ..lineTo(size.width * 0.91, size.height * 0.19)
      ..cubicTo(
        size.width * 0.81,
        size.height * 0.09,
        size.width * 0.67,
        size.height * 0.0,
        size.width * 0.5,
        size.height * 0.0,
      )
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.0,
        size.width * 0.13,
        size.height * 0.11,
        size.width * 0.05,
        size.height * 0.22,
      )
      ..lineTo(size.width * 0.26, size.height * 0.36)
      ..cubicTo(
        size.width * 0.31,
        size.height * 0.27,
        size.width * 0.39,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.2,
      )
      ..close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}