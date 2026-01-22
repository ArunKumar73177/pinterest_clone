import 'package:flutter/material.dart';

/// Pinterest-style onboarding screen with image collage and sign-up form
/// First screen users see when opening the app
class AuthEntryPage extends StatelessWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final collageHeight = screenHeight * 0.42; // 42vh from React code

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Collage Section - Overlapped style with animations
              SizedBox(
                height: collageHeight,
                child: Stack(
                  children: [
                    // Top Left - Home decor
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _ImageCard(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 130,
                        imageUrl:
                        'https://images.unsplash.com/photo-1617325279446-f0831b1d369d?w=400',
                        animationDelay: Duration.zero,
                      ),
                    ),

                    // Top Right - Portrait
                    Positioned(
                      top: 16,
                      right: 8,
                      child: _ImageCard(
                        width: MediaQuery.of(context).size.width * 0.36,
                        height: 145,
                        imageUrl:
                        'https://images.unsplash.com/photo-1512032234057-969150df7d71?w=400',
                        animationDelay: const Duration(milliseconds: 500),
                      ),
                    ),

                    // Center Top - Fashion outfit (highest z-index)
                    Positioned(
                      top: 35,
                      left: MediaQuery.of(context).size.width * 0.26,
                      child: _ImageCard(
                        width: MediaQuery.of(context).size.width * 0.48,
                        height: 200,
                        imageUrl:
                        'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400',
                        animationDelay: const Duration(milliseconds: 1000),
                      ),
                    ),

                    // Bottom Left - Dessert
                    Positioned(
                      bottom: 0,
                      left: 12,
                      child: _ImageCard(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 140,
                        imageUrl:
                        'https://images.unsplash.com/photo-1679942262057-d5732f732841?w=400',
                        animationDelay: const Duration(milliseconds: 1500),
                      ),
                    ),

                    // Bottom Right - Holiday
                    Positioned(
                      bottom: 8,
                      right: 12,
                      child: _ImageCard(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 125,
                        imageUrl:
                        'https://images.unsplash.com/photo-1767555800558-ba929aa4711e?w=400',
                        animationDelay: const Duration(milliseconds: 2000),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section - Logo, headline, form, legal text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Pinterest Logo - Circular red background
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE60023),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'P',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Headline - "Create a life you love"
                    const Text(
                      'Create a life\nyou love',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email Input Field
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey[800]!,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey[800]!,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey[700]!,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Continue Button - Red primary action
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle continue action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE60023),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Continue with Google Button - Dark outlined
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Google sign-in
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.grey[800]!,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Icon
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CustomPaint(
                                painter: _GoogleIconPainter(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Facebook Login Message
                    Column(
                      children: [
                        const Text(
                          'Facebook login is no longer available.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle account recovery
                          },
                          child: const Text(
                            'Recover your account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Legal Text - Terms and Privacy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w300,
                          ),
                          children: const [
                            TextSpan(
                              text: 'By continuing, you agree to Pinterest\'s ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' and acknowledge that you\'ve read our ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: '. '),
                            TextSpan(
                              text: 'Notice at collection',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual image card with rounded corners and subtle zoom animation
class _ImageCard extends StatefulWidget {
  final double width;
  final double height;
  final String imageUrl;
  final Duration animationDelay;

  const _ImageCard({
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.animationDelay,
  });

  @override
  State<_ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<_ImageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation after delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 32,
                    ),
                  );
                },
              ),
            );
          },
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
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.91, size.height * 0.51)
        ..lineTo(size.width * 0.91, size.height * 0.38)
        ..lineTo(size.width * 0.5, size.height * 0.38)
        ..lineTo(size.width * 0.5, size.height * 0.62)
        ..lineTo(size.width * 0.75, size.height * 0.62)
        ..cubicTo(
          size.width * 0.72,
          size.height * 0.72,
          size.width * 0.64,
          size.height * 0.79,
          size.width * 0.53,
          size.height * 0.79,
        )
        ..close(),
      paint,
    );

    // Green section (bottom right)
    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.96)
        ..cubicTo(
          size.width * 0.62,
          size.height * 0.96,
          size.width * 0.72,
          size.height * 0.91,
          size.width * 0.79,
          size.height * 0.83,
        )
        ..lineTo(size.width * 0.91, size.height * 0.73)
        ..cubicTo(
          size.width * 0.87,
          size.height * 0.81,
          size.width * 0.7,
          size.height * 0.96,
          size.width * 0.5,
          size.height * 0.96,
        )
        ..close(),
      paint,
    );

    // Yellow section (bottom left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.24, size.height * 0.59)
        ..cubicTo(
          size.width * 0.22,
          size.height * 0.55,
          size.width * 0.21,
          size.height * 0.53,
          size.width * 0.21,
          size.height * 0.5,
        )
        ..cubicTo(
          size.width * 0.21,
          size.height * 0.47,
          size.width * 0.22,
          size.height * 0.44,
          size.width * 0.24,
          size.height * 0.41,
        )
        ..lineTo(size.width * 0.09, size.height * 0.29)
        ..cubicTo(
          size.width * 0.06,
          size.height * 0.36,
          size.width * 0.04,
          size.height * 0.43,
          size.width * 0.04,
          size.height * 0.5,
        )
        ..cubicTo(
          size.width * 0.04,
          size.height * 0.57,
          size.width * 0.06,
          size.height * 0.64,
          size.width * 0.09,
          size.height * 0.71,
        )
        ..close(),
      paint,
    );

    // Red section (top left)
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.22)
        ..cubicTo(
          size.width * 0.57,
          size.height * 0.22,
          size.width * 0.63,
          size.height * 0.24,
          size.width * 0.68,
          size.height * 0.29,
        )
        ..lineTo(size.width * 0.81, size.height * 0.17)
        ..cubicTo(
          size.width * 0.73,
          size.height * 0.09,
          size.width * 0.62,
          size.height * 0.04,
          size.width * 0.5,
          size.height * 0.04,
        )
        ..cubicTo(
          size.width * 0.32,
          size.height * 0.04,
          size.width * 0.16,
          size.height * 0.14,
          size.width * 0.09,
          size.height * 0.29,
        )
        ..lineTo(size.width * 0.24, size.height * 0.41)
        ..cubicTo(
          size.width * 0.28,
          size.height * 0.3,
          size.width * 0.38,
          size.height * 0.22,
          size.width * 0.5,
          size.height * 0.22,
        )
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}