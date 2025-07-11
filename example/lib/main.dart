import 'package:flutter/material.dart';
import 'package:flutter_secure_wrap/flutter_secure_wrap.dart';

/// ---------------------------------------------------------------------------
/// Entry point of the application. Runs [MyApp].
/// ---------------------------------------------------------------------------
void main() {
  runApp(const MyApp());
}

/// ---------------------------------------------------------------------------
/// Root widget that sets up the application theme and home page.
/// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Content Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Stateful home page widget that displays user details securely.
/// ---------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// -------------------------------------------------------------------------
  /// User mock data. Replace with real data source in production.
  /// -------------------------------------------------------------------------
  final String _userName = 'User';
  final String _userEmail = 'user@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_userName details'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoCard(name: _userName, email: _userEmail),
            const SizedBox(height: 16),
            _AccountDetails(),
            const SizedBox(height: 16),
            Row(
              children: const [
                SecureImageCard(
                  title: 'Bank passbook',
                  imageUrl:
                      'https://5.imimg.com/data5/DL/NF/ZH/SELLER-85845681/sbi-black-passbook-1000x1000.jpg',
                ),
                SizedBox(width: 16),
                SecureImageCard(
                  title: 'PAN Card',
                  imageUrl:
                      'https://5.imimg.com/data5/DL/NF/ZH/SELLER-85845681/sbi-black-passbook-1000x1000.jpg',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SecureImageCard(
              title: 'Aadhaar Card',
              imageUrl:
                  'https://5.imimg.com/data5/DL/NF/ZH/SELLER-85845681/sbi-black-passbook-1000x1000.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Card displaying the user's basic information: avatar, name, and email.
/// ---------------------------------------------------------------------------
class UserInfoCard extends StatelessWidget {
  final String name;
  final String email;

  const UserInfoCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text(email),
        trailing: const Icon(Icons.edit, color: Colors.blueGrey),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Card holding multiple secure and non‑secure account details rows.
/// ---------------------------------------------------------------------------
class _AccountDetails extends StatelessWidget {
  const _AccountDetails();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            InfoRow(label: 'Phone number', value: '+91 9876543210'),
            InfoRow.secure(label: 'Account number', value: '2344-3443-1234'),
            InfoRow.secure(
              label: 'IFSC code',
              value: 'IBO009900D',
              autoHide: true,
            ),
            InfoRow.secure(label: 'PIN', value: '3452'),
            InfoRow(label: 'Branch address', value: 'xxx yyy zzz'),
            InfoRow(label: 'Membership', value: 'zzz'),
            InfoRow(label: 'Last Login', value: '10 July 2025, 9:45 PM'),
            InfoRow.secure(label: 'PAN ID', value: 'PAN4555555Q12'),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Row widget used for displaying secure and non‑secure pieces of information.
/// ---------------------------------------------------------------------------
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSecure;
  final bool autoHide;

  const InfoRow({super.key, required this.label, required this.value})
    : isSecure = false,
      autoHide = false;

  const InfoRow.secure({
    super.key,
    required this.label,
    required this.value,
    this.autoHide = false,
  }) : isSecure = true;

  @override
  Widget build(BuildContext context) {
    Widget content = Text(value, style: TextStyle(color: Colors.grey[700]));

    if (isSecure) {
      content = SecureContent(
        autoHide: autoHide,
        iconColor: Colors.blueGrey,
        child: content,
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            content,
          ],
        ),
        const Divider(),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Card widget for sensitive images such as documents.
/// ---------------------------------------------------------------------------
class SecureImageCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const SecureImageCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        SecureContent(
          iconColor: Colors.blueGrey,
          child: SizedBox(
            height: 150,
            width: 150,
            child: Card(
              elevation: 1,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
