import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../navigation/providers/route_provider.dart';
import '../providers/destination_provider.dart';
import '../providers/search_provider.dart';

class SearchPanel extends ConsumerStatefulWidget {
  const SearchPanel({
    super.key,
    this.onDestinationSelected,
  });

  final VoidCallback? onDestinationSelected;

  @override
  ConsumerState<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends ConsumerState<SearchPanel> {
  final TextEditingController _controller =
      TextEditingController();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        ref
            .read(searchProvider.notifier)
            .search(value);
      },
    );

    setState(() {});
  }

  void _clearSearch() {
    _controller.clear();

    ref
        .read(searchProvider.notifier)
        .clearResults();

    ref
        .read(destinationProvider.notifier)
        .clearDestination();

    ref
        .read(routeProvider.notifier)
        .clearRoute();

    setState(() {});
  }

  void _selectResult(dynamic result) {
    ref
        .read(destinationProvider.notifier)
        .setDestination(result);

    ref
        .read(searchProvider.notifier)
        .clearResults();

    _controller.text = result.displayName;

    widget.onDestinationSelected?.call();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    final hasText =
        _controller.text.trim().isNotEmpty;
    final hasResults =
        searchState.results.isNotEmpty;

    return Material(
      elevation: 8,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: l10n.searchDestinationHint,
                hintStyle: TextStyle(
                  color: theme
                      .colorScheme
                      .onSurfaceVariant,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.primary,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 4,
                ),
                suffixIcon:
                    searchState.isLoading
                        ? const Padding(
                            padding:
                                EdgeInsets.all(14),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : hasText
                            ? IconButton(
                                tooltip: l10n.clearSearch,
                                icon: const Icon(
                                  Icons.clear,
                                ),
                                onPressed:
                                    _clearSearch,
                              )
                            : null,
              ),
            ),
            if (hasResults) ...[
              Divider(
                height: 1,
                color: theme.dividerColor,
              ),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxHeight: 280,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  itemCount:
                      searchState.results.length,
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return Divider(
                      height: 1,
                      indent: 56,
                      color: theme.dividerColor,
                    );
                  },
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    final result =
                        searchState.results[index];

                    return ListTile(
                      dense: true,
                      minVerticalPadding: 10,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: theme
                            .colorScheme
                            .primaryContainer,
                        child: Icon(
                          Icons.location_on,
                          size: 20,
                          color: theme
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                      ),
                      title: Text(
                        result.displayName,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        _selectResult(result);
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}