import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/sensor/location_data.dart';

import 'package:awarex/providers/sensor/location_provider.dart';
import 'package:awarex/providers/sensor/permission_provider.dart';

import 'package:awarex/providers/context/context_provider.dart';
import 'package:awarex/providers/threat/threat_provider.dart';
import 'package:awarex/providers/safety/safety_provider.dart';

import 'package:awarex/widgets/diagnostics/battery_card.dart';
import 'package:awarex/widgets/diagnostics/context_card.dart';
import 'package:awarex/widgets/diagnostics/device_card.dart';
import 'package:awarex/widgets/diagnostics/diagnostic_card.dart';
import 'package:awarex/widgets/diagnostics/diagnostic_tile.dart';
import 'package:awarex/widgets/diagnostics/motion_card.dart';
import 'package:awarex/widgets/diagnostics/safety_state_card.dart';
import 'package:awarex/widgets/diagnostics/section_title.dart';
import 'package:awarex/widgets/diagnostics/threat_card.dart';
import 'package:awarex/providers/emergency/emergency_provider.dart';
import 'package:awarex/widgets/diagnostics/emergency_card.dart';

class DeveloperDiagnosticsScreen extends ConsumerStatefulWidget {
  const DeveloperDiagnosticsScreen({super.key});

  @override
  ConsumerState<DeveloperDiagnosticsScreen> createState() =>
      _DeveloperDiagnosticsScreenState();
}

class _DeveloperDiagnosticsScreenState
    extends ConsumerState<DeveloperDiagnosticsScreen> {
  bool _loading = true;
  bool _permissionGranted = false;
  bool _gpsEnabled = false;

  LocationData? _location;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final permissionService = ref.read(permissionServiceProvider);
      final locationService = ref.read(locationServiceProvider);

      final permission = await permissionService.ensureLocationPermission();

      final gps = await locationService.isLocationServiceEnabled();

      LocationData? location;

      if (permission && gps) {
        location = await locationService.getCurrentLocation();
      }

      if (!mounted) return;

      setState(() {
        _permissionGranted = permission;
        _gpsEnabled = gps;
        _location = location;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contextAsync = ref.watch(contextProvider);
    final threatAsync = ref.watch(threatProvider);
    final safetyAsync = ref.watch(safetyStateProvider);
    final emergencyAsync = ref.watch(emergencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Developer Diagnostics')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle(title: 'Application'),

            const DiagnosticCard(
              child: DiagnosticTile(
                label: 'Status',
                value: 'Running',
                valueColor: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Permissions'),

            DiagnosticCard(
              child: DiagnosticTile(
                label: 'Location Permission',
                value: _permissionGranted ? 'Granted' : 'Denied',
                valueColor: _permissionGranted ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Location'),

            DiagnosticCard(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _error != null
                  ? Text(_error!, style: const TextStyle(color: Colors.red))
                  : Column(
                      children: [
                        DiagnosticTile(
                          label: 'GPS Enabled',
                          value: _gpsEnabled ? 'Yes' : 'No',
                          valueColor: _gpsEnabled ? Colors.green : Colors.red,
                        ),
                        DiagnosticTile(
                          label: 'Latitude',
                          value: _location?.latitude.toStringAsFixed(6) ?? '-',
                        ),
                        DiagnosticTile(
                          label: 'Longitude',
                          value: _location?.longitude.toStringAsFixed(6) ?? '-',
                        ),
                        DiagnosticTile(
                          label: 'Accuracy',
                          value: _location == null
                              ? '-'
                              : '${_location!.accuracy.toStringAsFixed(1)} m',
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: _refresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Motion'),
            const MotionCard(),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Battery'),
            const BatteryCard(),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Device'),
            const DeviceCard(),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Context'),

            contextAsync.when(
              data: (context) => ContextCard(context: context),
              loading: () => const DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Threat Assessment'),

            threatAsync.when(
              data: (threat) => ThreatCard(threat: threat),
              loading: () => const DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SectionTitle(title: 'Safety State'),

            safetyAsync.when(
              data: (safety) => SafetyStateCard(safety: safety),
              loading: () => const DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const SectionTitle(title: 'Emergency Response'),

            emergencyAsync.when(
              data: (emergency) => EmergencyCard(emergency: emergency),

              loading: () => const DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

              error: (error, _) => DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    error.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
