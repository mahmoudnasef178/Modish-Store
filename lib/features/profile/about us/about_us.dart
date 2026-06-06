import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height * 0.32;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: headerHeight,
            pinned: true,
            backgroundColor: kPrimaryColor,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(size.shortestSide * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: size.shortestSide * 0.045,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff9F8383), Color(0xff574964)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -size.shortestSide * 0.1,
                    right: -size.shortestSide * 0.075,
                    child: Container(
                      width: size.shortestSide * 0.45,
                      height: size.shortestSide * 0.45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -size.shortestSide * 0.05,
                    left: -size.shortestSide * 0.05,
                    child: Container(
                      width: size.shortestSide * 0.3,
                      height: size.shortestSide * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Container(
                        width: size.shortestSide * 0.2,
                        height: size.shortestSide * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'M',
                            style: TextStyle(
                              fontSize: size.shortestSide * 0.1,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Text(
                        'Modish',
                        style: TextStyle(
                          fontSize: size.shortestSide * 0.07,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        'Fashion meets simplicity',
                        style: TextStyle(
                          fontSize: size.shortestSide * 0.035,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionCard(
                    icon: Icons.favorite_rounded,
                    title: 'Welcome to Modish!',
                    content:
                        'At Modish, fashion meets simplicity. We\'re a modern clothing e-commerce platform built to help you find trendy, affordable, and high-quality outfits from the comfort of your home.',
                  ),
                  SizedBox(height: size.height * 0.02),
                  _SectionCard(
                    icon: Icons.flag_rounded,
                    title: 'Our Mission',
                    content:
                        'We believe fashion should be accessible and enjoyable for everyone. Our mission is to bring you a seamless online shopping experience with curated collections that fit your style and budget.',
                  ),
                  SizedBox(height: size.height * 0.02),
                  const _WhyShopCard(),
                  SizedBox(height: size.height * 0.02),
                  const _ContactCard(),
                  SizedBox(height: size.height * 0.04),
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: secondaryColorText,
                        fontSize: size.shortestSide * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Center(
                    child: Text(
                      '© 2026 Modish. All rights reserved.',
                      style: TextStyle(
                        color: secondaryColorText,
                        fontSize: size.shortestSide * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconBoxSize = size.shortestSide * 0.1;
    final titleFontSize = size.shortestSide * 0.04;
    final contentFontSize = size.shortestSide * 0.033;

    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: kPrimaryColor,
                  size: iconBoxSize * 0.5,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w800,
                    color: primaryColorText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            content,
            style: TextStyle(
              fontSize: contentFontSize,
              color: secondaryColorText,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyShopCard extends StatelessWidget {
  const _WhyShopCard();

  final List<Map<String, dynamic>> features = const [
    {
      'icon': Icons.trending_up_rounded,
      'title': 'Trend-Driven Collections',
      'subtitle': 'Updated frequently with the latest styles.',
    },
    {
      'icon': Icons.verified_rounded,
      'title': 'Quality First',
      'subtitle': 'We partner with top-tier manufacturers.',
    },
    {
      'icon': Icons.local_shipping_rounded,
      'title': 'Fast Delivery',
      'subtitle': 'Swift and reliable shipping to your door.',
    },
    {
      'icon': Icons.lock_rounded,
      'title': 'Secure Payments',
      'subtitle': 'Your data is always safe with us.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconBoxSize = size.shortestSide * 0.1;
    final featureBoxSize = size.shortestSide * 0.09;
    final titleFontSize = size.shortestSide * 0.04;
    final subFontSize = size.shortestSide * 0.03;

    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: kPrimaryColor,
                  size: iconBoxSize * 0.5,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Text(
                'Why Shop With Us?',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w800,
                  color: primaryColorText,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          ...features.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.015),
              child: Row(
                children: [
                  Container(
                    width: featureBoxSize,
                    height: featureBoxSize,
                    decoration: BoxDecoration(
                      color: const Color(0xffF3EDE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      f['icon'] as IconData,
                      color: kPrimaryColor,
                      size: featureBoxSize * 0.5,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: TextStyle(
                            fontSize: subFontSize * 1.1,
                            fontWeight: FontWeight.w700,
                            color: primaryColorText,
                          ),
                        ),
                        Text(
                          f['subtitle'] as String,
                          style: TextStyle(
                            fontSize: subFontSize,
                            color: secondaryColorText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconBoxSize = size.shortestSide * 0.1;
    final titleFontSize = size.shortestSide * 0.04;
    final contentFontSize = size.shortestSide * 0.033;

    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.contact_mail_rounded,
                  color: kPrimaryColor,
                  size: iconBoxSize * 0.5,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w800,
                  color: primaryColorText,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          _ContactItem(
            icon: Icons.email_rounded,
            text: 'support@modish.com',
            fontSize: contentFontSize,
          ),
          SizedBox(height: size.height * 0.012),
          _ContactItem(
            icon: Icons.phone_rounded,
            text: '+20 100 000 0000',
            fontSize: contentFontSize,
          ),
          SizedBox(height: size.height * 0.012),
          _ContactItem(
            icon: Icons.location_on_rounded,
            text: 'Cairo, Egypt',
            fontSize: contentFontSize,
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontSize;

  const _ContactItem({
    required this.icon,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Icon(icon, color: kPrimaryColor, size: size.shortestSide * 0.045),
        SizedBox(width: size.width * 0.025),
        Text(
          text,
          style: TextStyle(fontSize: fontSize, color: secondaryColorText),
        ),
      ],
    );
  }
}
