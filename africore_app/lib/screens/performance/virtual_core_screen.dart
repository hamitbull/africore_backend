import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VirtualCoreScreen extends StatefulWidget {
  const VirtualCoreScreen({super.key});
  @override
  State<VirtualCoreScreen> createState() => _VirtualCoreScreenState();
}

class _VirtualCoreScreenState extends State<VirtualCoreScreen> {
  static const _channel = MethodChannel('com.africore.app/virtual_core');
  Timer? _timer;
  Map<String, dynamic> _metrics = {};
  String _profile = 'BALANCED';
  String _message = 'Starting performance monitor…';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('getMetrics');
      if (!mounted || result == null) return;
      setState(() { _metrics = result; _loading = false; });
    } on PlatformException catch (e) {
      if (mounted) setState(() { _message = e.message ?? 'Native monitor unavailable'; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _message = 'Performance metrics unavailable on this Android version'; _loading = false; });
    }
  }

  Future<void> _openBatterySettings() async {
    try {
      await _channel.invokeMethod('openBatterySettings');
    } catch (_) {
      if (mounted) setState(() => _message = 'Could not open Battery Saver settings');
    }
  }

  Color get _accent => const Color(0xFF00BFA6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF071321),
        foregroundColor: Colors.white,
        title: const Text('ASHIRU VIRTUAL CORE X'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PERFORMANCE INTELLIGENCE', style: TextStyle(color: _accent, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 8),
                const Text('Live device health overview', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(_loading ? _message : 'Monitoring active • refreshes every 3 seconds', style: const TextStyle(color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _metric('CPU LOAD', _value('cpuLoad'), Icons.memory)),
              const SizedBox(width: 10),
              Expanded(child: _metric('CPU CORES', _value('cpuCores'), Icons.developer_board)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _metric('AVAILABLE RAM', _value('availableRam'), Icons.storage)),
              const SizedBox(width: 10),
              Expanded(child: _metric('TOTAL RAM', _value('totalRam'), Icons.sd_storage)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _metric('BATTERY', _value('batteryPercent'), Icons.battery_std)),
              const SizedBox(width: 10),
              Expanded(child: _metric('BATTERY TEMP', _value('batteryTemp'), Icons.thermostat)),
            ]),
            const SizedBox(height: 20),
            const Text('VIRTUAL CORE PROFILES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _panel(child: Column(children: [
              _profileTile('BATTERY SAVER', 'Prioritize lower app activity', Icons.battery_saver),
              _profileTile('BALANCED', 'Default monitoring profile', Icons.balance),
              _profileTile('PERFORMANCE', 'Prioritize foreground app responsiveness', Icons.speed),
            ])),
            const SizedBox(height: 18),
            SizedBox(height: 52, child: ElevatedButton.icon(
              onPressed: _openBatterySettings,
              icon: const Icon(Icons.settings),
              label: const Text('OPEN ANDROID BATTERY SETTINGS'),
              style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.black),
            )),
            const SizedBox(height: 16),
            _panel(child: const Text(
              'IMPORTANT HARDWARE LIMIT: Android apps cannot add physical RAM or CPU cores, freely change CPU speed, or close other apps safely. Profiles in this version are app-level modes; actual system power saving is controlled by Android.',
              style: TextStyle(color: Color(0xFFFFD59A), height: 1.45),
            )),
            if (_message.isNotEmpty && !_loading) Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(_message, style: const TextStyle(color: Colors.white54)),
            ),
          ],
        ),
      ),
    );
  }

  String _value(String key) => (_metrics[key] ?? 'Unavailable').toString();

  Widget _panel({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF12243A), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white10)),
    child: child,
  );

  Widget _metric(String title, String value, IconData icon) => _panel(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: _accent),
      const SizedBox(height: 12),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      const SizedBox(height: 4),
      Text(title, style: const TextStyle(color: Colors.white60, fontSize: 11)),
    ]),
  );

  Widget _profileTile(String name, String subtitle, IconData icon) => RadioListTile<String>(
    value: name == 'BATTERY SAVER' ? 'BATTERY' : name,
    groupValue: _profile,
    activeColor: _accent,
    contentPadding: EdgeInsets.zero,
    title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60)),
    secondary: Icon(icon, color: _accent),
    onChanged: (v) { if (v != null) setState(() { _profile = v; _message = 'Selected $_profile profile. Android system tuning is not changed.'; }); },
  );
}
