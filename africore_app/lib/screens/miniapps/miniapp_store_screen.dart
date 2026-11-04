import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/config/api_endpoints.dart';
import '../../core/services/api_service.dart';

class MiniAppStoreScreen extends StatefulWidget {
  const MiniAppStoreScreen({super.key});

  @override
  State<MiniAppStoreScreen> createState() => _MiniAppStoreScreenState();
}

class _MiniAppStoreScreenState extends State<MiniAppStoreScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _apps = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await ApiService.instance.get(ApiEndpoints.miniapps);
      final payload = response.data;
      final List<dynamic> values = payload is List
          ? payload
          : payload is Map && payload['apps'] is List
              ? payload['apps'] as List
              : payload is Map && payload['data'] is List
                  ? payload['data'] as List
                  : <dynamic>[];
      final apps = values
          .whereType<Map>()
          .map((value) => Map<String, dynamic>.from(value))
          .where((app) => (app['appUrl'] ?? '').toString().startsWith('https://'))
          .toList();

      if (!mounted) return;
      setState(() => _apps = apps);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openApp(Map<String, dynamic> app) {
    final uri = Uri.tryParse((app['appUrl'] ?? '').toString());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This mini app does not have a valid secure URL.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MiniAppWebViewScreen(
          title: (app['name'] ?? 'Mini App').toString(),
          uri: uri,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini App Store'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadApps,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, size: 48),
                        const SizedBox(height: 12),
                        const Text('Could not load mini apps.'),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadApps,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                )
              : _apps.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No approved mini apps are available yet.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadApps,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _apps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final app = _apps[index];
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.apps),
                              ),
                              title: Text((app['name'] ?? 'Mini App').toString()),
                              subtitle: Text(
                                (app['description'] ?? app['category'] ?? '').toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () => _openApp(app),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

class MiniAppWebViewScreen extends StatefulWidget {
  const MiniAppWebViewScreen({
    super.key,
    required this.title,
    required this.uri,
  });

  final String title;
  final Uri uri;

  @override
  State<MiniAppWebViewScreen> createState() => _MiniAppWebViewScreenState();
}

class _MiniAppWebViewScreenState extends State<MiniAppWebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _loading = false;
                _error = error.description;
              });
            }
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null || uri.scheme != 'https') {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Mini app could not be opened: $_error'),
              ),
            ),
        ],
      ),
    );
  }
}
