import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../map/providers/location_provider.dart';

import '../models/event_type.dart';

import '../providers/event_types_provider.dart';
import '../providers/report_controller.dart';
import '../providers/report_provider.dart';

import '../services/nearest_way_service.dart';

import '../widgets/location_picker_page.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({
    super.key,
  });

  @override
  ConsumerState<ReportPage> createState() =>
      _ReportPageState();
}

class _ReportPageState
    extends ConsumerState<ReportPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _titleController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final NearestWayService
      _nearestWayService =
      NearestWayService();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation(
    LatLng currentLocation,
  ) async {
    final result =
        await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LocationPickerPage(
          initialLocation:
              currentLocation,
        ),
      ),
    );

    if (result != null) {
      ref
          .read(
            reportProvider.notifier,
          )
          .setSelectedLocation(
            result,
          );
    }
  }

  Future<void> _submitReport() async {
    final reportState =
        ref.read(reportProvider);

    final reportNotifier =
        ref.read(
          reportProvider.notifier,
        );

    final controller =
        ref.read(
          reportControllerProvider,
        );

    final position =
        await ref.read(
          currentLocationProvider.future,
        );

    if (reportState.selectedEventType ==
        null) {
      return;
    }

    final latitude =
        reportState
                .selectedLocation
                ?.latitude ??
            position.latitude;

    final longitude =
        reportState
                .selectedLocation
                ?.longitude ??
            position.longitude;

    try {
      reportNotifier.setSubmitting(
        true,
      );

      // Resolve the selected location to
      // the nearest OSM road segment.
      final nearestWay =
          await _nearestWayService
              .resolveNearestWay(
        LatLng(
          latitude,
          longitude,
        ),
      );

      debugPrint(
        '========== INCIDENT ROAD SNAP =========='
      );

      debugPrint(
        'Original latitude: $latitude',
      );

      debugPrint(
        'Original longitude: $longitude',
      );

      debugPrint(
        'Snapped latitude: '
        '${nearestWay.snappedLatitude}',
      );

      debugPrint(
        'Snapped longitude: '
        '${nearestWay.snappedLongitude}',
      );

      debugPrint(
        'Distance from road: '
        '${nearestWay.distanceMeters} m',
      );

      debugPrint(
        'OSM way ID: '
        '${nearestWay.osmWayId}',
      );

      debugPrint(
        '========================================'
      );

      // IMPORTANT:
      //
      // Store the snapped road coordinates,
      // not the original map-tap coordinates.
      final reportId =
          await controller.submitReport(
        title:
            _titleController.text.trim(),
        description:
            _descriptionController.text.trim(),
        latitude:
            nearestWay.snappedLatitude,
        longitude:
            nearestWay.snappedLongitude,
        eventType:
            reportState.selectedEventType!,
        osmWayId:
            nearestWay.osmWayId,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "Report submitted successfully!\n"
            "Road: "
            "${nearestWay.name ?? 'Unknown'}\n"
            "Distance from road: "
            "${nearestWay.distanceMeters.toStringAsFixed(1)} m\n"
            "ID: $reportId",
          ),
        ),
      );

      _formKey.currentState?.reset();

      _titleController.clear();

      _descriptionController.clear();

      reportNotifier.reset();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.red,
          content: Text(
            "Failed to submit report\n$e",
          ),
        ),
      );
    } finally {
      reportNotifier.setSubmitting(
        false,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final reportState =
        ref.watch(reportProvider);

    final reportNotifier =
        ref.read(
          reportProvider.notifier,
        );

    final location =
        ref.watch(
          currentLocationProvider,
        );

    final eventTypes =
        ref.watch(
          eventTypesProvider,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Incident",
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: location.when(
          loading: () =>
              const Center(
            child:
                CircularProgressIndicator(),
          ),
          error: (
            error,
            stackTrace,
          ) =>
              Center(
            child:
                Text(
              error.toString(),
            ),
          ),
          data: (position) {
            final selectedLocation =
                reportState
                        .selectedLocation ??
                    LatLng(
                      position.latitude,
                      position.longitude,
                    );

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons
                                      .location_on,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Incident Location",
                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Latitude : "
                              "${selectedLocation.latitude.toStringAsFixed(5)}",
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Longitude : "
                              "${selectedLocation.longitude.toStringAsFixed(5)}",
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width:
                                  double.infinity,
                              child:
                                  OutlinedButton
                                      .icon(
                                icon:
                                    const Icon(
                                  Icons.map,
                                ),
                                label:
                                    const Text(
                                  "Choose on Map",
                                ),
                                onPressed:
                                    () =>
                                        _pickLocation(
                                  LatLng(
                                    position
                                        .latitude,
                                    position
                                        .longitude,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller:
                          _titleController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Incident Title",
                        border:
                            OutlineInputBorder(),
                        prefixIcon:
                            Icon(
                          Icons.title,
                        ),
                      ),
                      validator:
                          (value) {
                        if (value ==
                                null ||
                            value
                                .trim()
                                .isEmpty) {
                          return "Enter incident title";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller:
                          _descriptionController,
                      minLines: 4,
                      maxLines: 6,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Description (Optional)",
                        border:
                            OutlineInputBorder(),
                        prefixIcon:
                            Icon(
                          Icons.description,
                        ),
                      ),
                      validator:
                          (_) => null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    eventTypes.when(
                      loading: () =>
                          const Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                      error: (
                        error,
                        stackTrace,
                      ) =>
                          Text(
                        "Failed to load event types\n$error",
                      ),
                      data: (types) {
                        return DropdownButtonFormField<
                            EventType>(
                          initialValue:
                              reportState
                                  .selectedEventType,
                          decoration:
                              const InputDecoration(
                            labelText:
                                "Incident Type",
                            border:
                                OutlineInputBorder(),
                            prefixIcon:
                                Icon(
                              Icons
                                  .warning_amber_rounded,
                            ),
                          ),
                          items: types
                              .map(
                            (
                              eventType,
                            ) =>
                                DropdownMenuItem<
                                    EventType>(
                              value:
                                  eventType,
                              child:
                                  Text(
                                eventType
                                    .name,
                              ),
                            ),
                          )
                              .toList(),
                          onChanged:
                              (value) {
                            if (value !=
                                null) {
                              reportNotifier
                                  .setSelectedEventType(
                                value,
                              );
                            }
                          },
                          validator:
                              (value) {
                            if (value ==
                                null) {
                              return "Please select an incident type";
                            }

                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width:
                          double.infinity,
                      height: 55,
                      child:
                          FilledButton.icon(
                        onPressed:
                            reportState
                                    .isSubmitting
                                ? null
                                : () async {
                                    if (!_formKey
                                        .currentState!
                                        .validate()) {
                                      return;
                                    }

                                    await _submitReport();
                                  },
                        icon: reportState
                                .isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                              ),
                        label: Text(
                          reportState
                                  .isSubmitting
                              ? "Resolving Road..."
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