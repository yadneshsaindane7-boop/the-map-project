import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../map/providers/location_provider.dart';
import '../models/event_type.dart';
import '../providers/event_types_provider.dart';
import '../providers/report_provider.dart';
import '../providers/report_repository_provider.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final reportState = ref.read(reportProvider);
    final reportNotifier = ref.read(reportProvider.notifier);
    final repository = ref.read(reportRepositoryProvider);

    final position = await ref.read(currentLocationProvider.future);

    if (reportState.selectedEventType == null) {
      return;
    }

    try {
      reportNotifier.setSubmitting(true);

      final reportId = await repository.submitReport(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        latitude: position.latitude,
        longitude: position.longitude,
        eventType: reportState.selectedEventType!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Report submitted successfully!\nID: $reportId',
          ),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState?.reset();

      _titleController.clear();
      _descriptionController.clear();

      reportNotifier.clearSelectedEventType();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit report\n$e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      reportNotifier.setSubmitting(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportProvider);
    final reportNotifier = ref.read(reportProvider.notifier);

    final location = ref.watch(currentLocationProvider);
    final eventTypes = ref.watch(eventTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: location.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          data: (position) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text("Current Location"),
                        subtitle: Text(
                          "${position.latitude}, ${position.longitude}",
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Incident Title",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter incident title";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter description";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    eventTypes.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Text(
                        "Failed to load event types\n$error",
                      ),
                      data: (types) {
                        return DropdownButtonFormField<EventType>(
                          initialValue: reportState.selectedEventType,
                          decoration: const InputDecoration(
                            labelText: "Incident Type",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.warning_amber_rounded),
                          ),
                          items: types
                              .map(
                                (eventType) => DropdownMenuItem<EventType>(
                                  value: eventType,
                                  child: Text(eventType.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              reportNotifier.setSelectedEventType(value);
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select an incident type";
                            }
                            return null;
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: FilledButton.icon(
                        onPressed: reportState.isSubmitting
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                await _submitReport();
                              },
                        icon: reportState.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                          reportState.isSubmitting
                              ? "Submitting..."
                              : "Submit Incident",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}