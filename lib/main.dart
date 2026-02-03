import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const GeoSemApp());
}

class GeoSemApp extends StatelessWidget {
  const GeoSemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoSem - KNUST Geography Seminar Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF006633), // KNUST Green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006633),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF006633), // KNUST Green
          foregroundColor: Colors.white,
          elevation: 2,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        useMaterial3: true,
      ),
      home: const GeoSemHomePage(),
    );
  }
}

class GeoSemHomePage extends StatefulWidget {
  const GeoSemHomePage({super.key});

  @override
  State<GeoSemHomePage> createState() => _GeoSemHomePageState();
}

class _GeoSemHomePageState extends State<GeoSemHomePage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _loadingMessage = 'Loading GeoSem...';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress if needed
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadingMessage = 'Loading GeoSem...';
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _loadingMessage = 'Failed to load GeoSem';
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse('http://localhost:3000'), // React app URL
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700), // KNUST Gold
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school,
                color: Color(0xFF006633), // KNUST Green
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'GeoSem',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            Text(
              'KNUST Geography',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAboutDialog();
            },
            tooltip: 'About',
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006633), // KNUST Green
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Color(0xFFFFD700), // KNUST Gold
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'GeoSem',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006633), // KNUST Green
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _loadingMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF006633), // KNUST Green
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Department of Geography and Rural Development',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'GeoSem',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF006633), // KNUST Green
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.school,
          color: Color(0xFFFFD700), // KNUST Gold
          size: 28,
        ),
      ),
      children: [
        const Text('KNUST Geography Seminar Management System'),
        const SizedBox(height: 8),
        const Text(
          'A comprehensive platform for organizing, managing, and tracking academic seminars, workshops, and presentations within the Department of Geography and Rural Development.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        const Text(
          'Kwame Nkrumah University of Science and Technology\nDepartment of Geography and Rural Development',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006633), // KNUST Green
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
