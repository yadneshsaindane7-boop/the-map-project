import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../l10n/app_localizations.dart';
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

class _ReportPageState extends ConsumerState<ReportPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final NearestWayService _nearestWayService =
      NearestWayService();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation(
    LatLng initialLocation,
  ) async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
          initialLocation: initialLocation,
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    ref.read(reportProvider.notifier).setSelectedLocation(result);
  }

  Future<void> _submitReport() async {
    final l10n = AppLocalizations.of(context)!;
    final reportState = ref.read(reportProvider);
    final reportNotifier = ref.read(reportProvider.notifier);
    final controller = ref.read(reportControllerProvider);

    if (reportState.selectedEventType == null) {
      return;
    }

    final position = await ref.read(
      currentLocationProvider.future,
    );

    final latitude =
        reportState.selectedLocation?.latitude ??
            position.latitude;

    final longitude =
        reportState.selectedLocation?.longitude ??
            position.longitude;

    try {
      reportNotifier.setSubmitting(true);

      final nearestWay =
          await _nearestWayService.resolveNearestWay(
        LatLng(
          latitude,
          longitude,
        ),
      );

      debugPrint(
        '========== INCIDENT ROAD SNAP ==========',
      );

      debugPrint('Original latitude: $latitude');
      debugPrint('Original longitude: $longitude');

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
        '========================================',
      );

      await controller.submitReport(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        latitude: nearestWay.snappedLatitude,
        longitude: nearestWay.snappedLongitude,
        eventType: reportState.selectedEventType!,
        osmWayId: nearestWay.osmWayId,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor:
              Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.reportSuccessMessage,
                ),
              ),
            ],
          ),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();

      _formKey.currentState?.reset();

      reportNotifier.reset();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor:
              Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context)
                    .colorScheme
                    .onError,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.reportErrorMessage(
                    error.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } finally {
      if (mounted) {
        reportNotifier.setSubmitting(false);
      }
    }
  }

  Future<EventType?> _showEventTypePicker({
    required BuildContext context,
    required List<EventType> types,
    required EventType? selectedType,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return showModalBottomSheet<EventType>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 520,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 24,
                  offset: Offset(0, -6),
                  color: Colors.black26,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.35),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: theme
                              .colorScheme
                              .primaryContainer,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: theme
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.incidentType,
                              style: theme
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.whatIsHappening,
                              style: theme
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: theme
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.close,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: theme.dividerColor,
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.fromLTRB(
                      12,
                      12,
                      12,
                      20,
                    ),
                    itemCount: types.length,
                    separatorBuilder:
                        (context, index) {
                      return const SizedBox(
                        height: 6,
                      );
                    },
                    itemBuilder:
                        (context, index) {
                      final type = types[index];

                      final isSelected =
                          selectedType?.id == type.id;

                      return _EventTypeOption(
                        type: type,
                        isSelected: isSelected,
                        onTap: () {
                          Navigator.pop(
                            context,
                            type,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _fieldDecoration({
    required BuildContext context,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    final theme = Theme.of(context);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.dividerColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.dividerColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 1.5,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportState = ref.watch(reportProvider);
    final reportNotifier = ref.read(reportProvider.notifier);
    final location = ref.watch(currentLocationProvider);
    final eventTypes = ref.watch(eventTypesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(78),
        child: _ReportAppBar(),
      ),
      body: SafeArea(
        child: location.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => _LocationError(
            error: error,
          ),
          data: (position) {
            final currentLocation = LatLng(
              position.latitude,
              position.longitude,
            );

            final selectedLocation =
                reportState.selectedLocation ??
                    currentLocation;

            final hasSelectedLocation =
                reportState.selectedLocation != null;

            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                28,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(
                      icon:
                          Icons.location_on_outlined,
                      title: l10n.incidentLocation,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shadowColor: Colors.black12,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: hasSelectedLocation
                                    ? theme
                                        .colorScheme
                                        .primaryContainer
                                    : theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    hasSelectedLocation
                                        ? Icons.location_on
                                        : Icons.my_location,
                                    size: 20,
                                    color: hasSelectedLocation
                                        ? theme
                                            .colorScheme
                                            .onPrimaryContainer
                                        : theme
                                            .colorScheme
                                            .primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      hasSelectedLocation
                                          ? l10n.locationSelectedOnMap
                                          : l10n.usingCurrentLocation,
                                      style: TextStyle(
                                        color: hasSelectedLocation
                                            ? theme
                                                .colorScheme
                                                .onPrimaryContainer
                                            : theme
                                                .colorScheme
                                                .onSurface,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (hasSelectedLocation)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 20,
                                      color: theme
                                          .colorScheme
                                          .primary,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _CoordinateTile(
                                    label: l10n.latitude,
                                    value:
                                        selectedLocation
                                            .latitude
                                            .toStringAsFixed(5),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _CoordinateTile(
                                    label: l10n.longitude,
                                    value:
                                        selectedLocation
                                            .longitude
                                            .toStringAsFixed(5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child:
                                  OutlinedButton.icon(
                                onPressed:
                                    reportState.isSubmitting
                                        ? null
                                        : () => _pickLocation(
                                              selectedLocation,
                                            ),
                                icon: const Icon(
                                  Icons.map_outlined,
                                ),
                                label: Text(
                                  hasSelectedLocation
                                      ? l10n.changeLocation
                                      : l10n.chooseOnMap,
                                ),
                                style:
                                    OutlinedButton.styleFrom(
                                  minimumSize:
                                      const Size(
                                    double.infinity,
                                    50,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(
                      icon: Icons.edit_note,
                      title: l10n.incidentDetails,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _titleController,
                      textInputAction:
                          TextInputAction.next,
                      maxLength: 80,
                      decoration:
                          _fieldDecoration(
                        context: context,
                        label: l10n.incidentTitle,
                        icon: Icons.title,
                        hint: l10n.incidentTitleHint,
                      ).copyWith(
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return l10n
                              .incidentTitleEmptyError;
                        }

                        if (value.trim().length < 3) {
                          return l10n
                              .incidentTitleMinError;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      textInputAction:
                          TextInputAction.newline,
                      minLines: 4,
                      maxLines: 6,
                      maxLength: 500,
                      decoration:
                          _fieldDecoration(
                        context: context,
                        label:
                            l10n.incidentDescriptionOptional,
                        icon: Icons.description_outlined,
                        hint:
                            l10n.incidentDescriptionHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(
                      icon:
                          Icons.warning_amber_rounded,
                      title: l10n.incidentType,
                    ),
                    const SizedBox(height: 10),
                    eventTypes.when(
                      loading: () => Card(
                        margin: EdgeInsets.zero,
                        elevation: 1,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child:
                                CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      error: (
                        error,
                        stackTrace,
                      ) =>
                          _EventTypeError(
                        error: error,
                      ),
                      data: (types) {
                        return FormField<EventType>(
                          initialValue: reportState
                              .selectedEventType,
                          validator: (value) {
                            if (value == null) {
                              return l10n
                                  .selectIncidentTypeError;
                            }

                            return null;
                          },
                          builder: (field) {
                            final selectedType =
                                field.value;

                            return _IncidentTypeSelector(
                              selectedType:
                                  selectedType,
                              errorText:
                                  field.errorText,
                              enabled:
                                  !reportState.isSubmitting,
                              onTap: () async {
                                final selected =
                                    await _showEventTypePicker(
                                  context: context,
                                  types: types,
                                  selectedType:
                                      selectedType,
                                );

                                if (selected == null) {
                                  return;
                                }

                                field.didChange(selected);

                                reportNotifier
                                    .setSelectedEventType(
                                  selected,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton.icon(
                        onPressed:
                            reportState.isSubmitting
                                ? null
                                : () async {
                                    final valid =
                                        _formKey
                                                .currentState
                                                ?.validate() ??
                                            false;

                                    if (!valid) {
                                      return;
                                    }

                                    await _submitReport();
                                  },
                        icon: reportState.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                              ),
                        label: Text(
                          reportState.isSubmitting
                              ? l10n.resolvingRoadAndSubmitting
                              : l10n.submitIncident,
                        ),
                        style:
                            FilledButton.styleFrom(
                          minimumSize:
                              const Size(
                            double.infinity,
                            54,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          textStyle:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.reportReviewDisclaimer,
                      textAlign: TextAlign.center,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
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

class _ReportAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Material(
      elevation: 2,
      color: theme.colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            10,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .primaryContainer,
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  size: 29,
                  color: theme
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.reportIncidentTitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.reportIncidentSubtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .secondaryContainer,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 21,
                  color: theme
                      .colorScheme
                      .onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncidentTypeSelector extends StatelessWidget {
  const _IncidentTypeSelector({
    required this.selectedType,
    required this.errorText,
    required this.enabled,
    required this.onTap,
  });

  final EventType? selectedType;
  final String? errorText;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final borderColor = errorText != null
        ? theme.colorScheme.error
        : theme.dividerColor;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Material(
          color: theme.colorScheme.surface,
          borderRadius:
              BorderRadius.circular(14),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(14),
            onTap: enabled ? onTap : null,
            child: Container(
              constraints:
                  const BoxConstraints(
                minHeight: 68,
              ),
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                10,
                10,
                10,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width:
                      errorText != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color:
                        theme.colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.incidentType,
                          style: theme
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        if (selectedType == null)
                          Text(
                            l10n.selectIncidentType,
                            style: theme
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          )
                        else
                          Row(
                            children: [
                              _EventTypeIcon(
                                type: selectedType!,
                                size: 19,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _localizedEventTypeName(
                                    context,
                                    selectedType!,
                                  ),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: theme
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding:
                const EdgeInsets.only(
              left: 12,
              top: 6,
            ),
            child: Text(
              errorText!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class _EventTypeOption extends StatelessWidget {
  const _EventTypeOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final EventType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = isSelected
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;

    final iconBackground = isSelected
        ? theme.colorScheme.surface
        : theme
            .colorScheme
            .surfaceContainerHighest;

    final textColor = isSelected
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    return Material(
      color: backgroundColor,
      borderRadius:
          BorderRadius.circular(16),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: _EventTypeIcon(
                  type: type,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _localizedEventTypeName(
                    context,
                    type,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    color: textColor,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color:
                      theme.colorScheme.primary,
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme
                      .colorScheme
                      .onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _localizedEventTypeName(
  BuildContext context,
  EventType type,
) {
  final l10n = AppLocalizations.of(context)!;
  final value =
      '${type.id} ${type.name}'.toLowerCase();

  if (value.contains('closure') ||
      value.contains('closed')) {
    return l10n.incidentRoadClosed;
  }

  if (value.contains('accident')) {
    return l10n.incidentAccident;
  }

  if (value.contains('construction')) {
    return l10n.incidentConstruction;
  }

  if (value.contains('flood')) {
    return l10n.incidentFlooding;
  }

  if (value.contains('traffic') ||
      value.contains('jam')) {
    return l10n.incidentTrafficJam;
  }

  if (value.contains('pothole')) {
    return l10n.incidentPothole;
  }

  if (value.contains('public') ||
      value.contains('event')) {
    return l10n.incidentPublicEvent;
  }

  if (value.contains('diversion')) {
    return l10n.incidentDiversion;
  }

  if (value.contains('other')) {
    return l10n.incidentOther;
  }

  return type.name;
}

class _EventTypeIcon extends StatelessWidget {
  const _EventTypeIcon({
    required this.type,
    this.size = 22,
  });

  final EventType type;
  final double size;

  IconData _iconForType() {
    final value =
        '${type.id} ${type.name}'.toLowerCase();

    if (value.contains('closure') ||
        value.contains('closed')) {
      return Icons.block_rounded;
    }

    if (value.contains('pothole')) {
      return Icons.report_problem_rounded;
    }

    if (value.contains('flood')) {
      return Icons.water_rounded;
    }

    if (value.contains('diversion')) {
      return Icons.alt_route_rounded;
    }

    if (value.contains('construction')) {
      return Icons.construction_rounded;
    }

    if (value.contains('accident')) {
      return Icons.car_crash_rounded;
    }

    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Icon(
      _iconForType(),
      color: theme.colorScheme.primary,
      size: size,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _CoordinateTile extends StatelessWidget {
  const _CoordinateTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationError extends StatelessWidget {
  const _LocationError({
    required this.error,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.unableToGetLocation,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventTypeError extends StatelessWidget {
  const _EventTypeError({
    required this.error,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color:
                theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.unableToLoadIncidentTypes(
                error.toString(),
              ),
              style: TextStyle(
                color:
                    theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
