import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailChooserSheet extends StatefulWidget {
  const EmailChooserSheet({super.key});

  @override
  State<EmailChooserSheet> createState() => _EmailChooserSheetState();
}

class _EmailChooserSheetState extends State<EmailChooserSheet> {
  bool _dontAskAgain = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconBoxSize = size.shortestSide * 0.16;
    final iconSize = iconBoxSize * 0.52;
    final fontSize = size.shortestSide * 0.032;
    final spacing = size.height * 0.02;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white70,
                size: size.shortestSide * 0.06,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AppItem(
                icon: Icons.mail_outline,
                iconColor: Colors.white,
                bgColor: const Color(0xFF0078D4),
                label: 'Outlook',
                iconBoxSize: iconBoxSize,
                iconSize: iconSize,
                fontSize: fontSize,
                onTap: () async {
                  Navigator.pop(context);
                  final Uri emailUri =
                      Uri(
                        scheme: 'mailto',
                        path: 'support@modishwear.com',
                      ).replace(
                        query:
                            'subject=Hello Modish Team&body=Hi, I have a question about...',
                      );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(
                      emailUri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
              ),
              SizedBox(width: size.width * 0.1),
              _AppItem(
                icon: Icons.mail,
                iconColor: const Color(0xFFEA4335),
                bgColor: Colors.white,
                label: 'Gmail',
                iconBoxSize: iconBoxSize,
                iconSize: iconSize,
                fontSize: fontSize,
                onTap: () async {
                  Navigator.pop(context);
                  final Uri emailUri =
                      Uri(
                        scheme: 'mailto',
                        path: 'support@modishwear.com',
                      ).replace(
                        query:
                            'subject=Hello Modish Team&body=Hi, I have a question about...',
                      );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  }
                },
              ),
            ],
          ),

          SizedBox(height: spacing),
          const Divider(color: Colors.white24),
          SizedBox(height: spacing * 0.5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _dontAskAgain,
                    onChanged: (val) =>
                        setState(() => _dontAskAgain = val ?? false),
                    checkColor: Colors.black,
                    activeColor: Colors.white54,
                    side: const BorderSide(color: Colors.white38),
                  ),
                  Text(
                    "Don't ask again",
                    style: TextStyle(color: Colors.white54, fontSize: fontSize),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Download more >',
                  style: TextStyle(
                    color: const Color(0xFF4DA6FF),
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final VoidCallback onTap;
  final double iconBoxSize;
  final double iconSize;
  final double fontSize;

  const _AppItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
    required this.iconBoxSize,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(iconBoxSize * 0.25),
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          SizedBox(height: iconBoxSize * 0.12),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
