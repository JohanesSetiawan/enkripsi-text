import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const EncryptionApp());
}

class EncryptionApp extends StatelessWidget {
  const EncryptionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _inputController = TextEditingController();
  String _encryptionResult = '';
  String _decryptionResult = '';
  final List<String> _encryptionHistory = [];
  final List<String> _decryptionHistory = [];

  void _encryptText() {
    String plainText = _inputController.text;
    String encryptedText = '';
    String decryptedText = '';

    // Algoritma enkripsi sederhana
    for (int i = plainText.length - 1; i >= 0; i--) {
      encryptedText += plainText[i];
    }

    setState(() {
      _encryptionResult = encryptedText;
      _encryptionHistory.add(encryptedText);
    });

    print('Hasil enkripsi: $encryptedText');
  }

  void _decryptText() {
    String encryptedText = _inputController.text;
    String decryptedText = '';

    // Algoritma dekripsi sederhana
    for (int i = encryptedText.length - 1; i >= 0; i--) {
      decryptedText += encryptedText[i];
    }

    decryptedText = decryptedText.split('').reversed.join('');

    print('Hasil dekripsi: $decryptedText');

    setState(() {
      _decryptionResult = decryptedText;
      _decryptionHistory.add(decryptedText);
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Teks berhasil disalin')),
    );
  }

  void _showEncryptionHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Riwayat Enkripsi'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _encryptionHistory.length,
              itemBuilder: (BuildContext context, int index) {
                final text = _encryptionHistory[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(text)),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyToClipboard(text),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showDecryptionHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Riwayat Dekripsi'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _decryptionHistory.length,
              itemBuilder: (BuildContext context, int index) {
                final text = _decryptionHistory[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(text)),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyToClipboard(text),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'encryptionHistory') {
                _showEncryptionHistoryDialog();
              } else if (value == 'decryptionHistory') {
                _showDecryptionHistoryDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'encryptionHistory',
                  child: Text('Riwayat Enkripsi'),
                ),
                const PopupMenuItem<String>(
                  value: 'decryptionHistory',
                  child: Text('Riwayat Dekripsi'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _inputController,
              decoration: const InputDecoration(
                hintText: 'Masukkan input text',
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _encryptText,
              child: const Text('Enkripsi'),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Text('Hasil enkripsi: $_encryptionResult'),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(_encryptionResult),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _decryptText,
        child: const Text('decrypt'),
      ),
    );
  }
}
