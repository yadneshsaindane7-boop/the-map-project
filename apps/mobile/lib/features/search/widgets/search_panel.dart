import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../navigation/providers/route_provider.dart';
import '../providers/destination_provider.dart';
import '../providers/search_provider.dart';

class SearchPanel extends ConsumerStatefulWidget {
  const SearchPanel({super.key, this.onDestinationSelected});

  final VoidCallback? onDestinationSelected;

  @override
  ConsumerState<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends ConsumerState<SearchPanel> {
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(value);
    });
  }

  void _clearSearch() {
    _controller.clear();

    ref.read(searchProvider.notifier).clearResults();

    ref.read(destinationProvider.notifier).clearDestination();

    ref.read(routeProvider.notifier).clearRoute();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search destination...',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                suffixIcon: searchState.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : (_controller.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )),
              ),
            ),
            if (searchState.results.isNotEmpty) ...[
              const Divider(height: 1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchState.results.length,
                  itemBuilder: (context, index) {
                    final result = searchState.results[index];

                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(
                        result.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        ref
                            .read(destinationProvider.notifier)
                            .setDestination(result);

                        ref.read(searchProvider.notifier).clearResults();

                        _controller.text = result.displayName;

                        widget.onDestinationSelected?.call();

                        setState(() {});
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
