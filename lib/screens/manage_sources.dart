import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/domains_state.dart';

class ManageSources extends ConsumerWidget {
  const ManageSources({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureDomains = ref.watch(domainsProvider);
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your sources'),
      ),
      body: futureDomains.when(
        data: (domains) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    ref.read(domainsProvider.notifier).add(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'e.g. ign.com',
                    label: const Text('Add new'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: domains.length,
                (context, index) => Dismissible(
                  key: Key(domains[index]),
                  background: Container(
                    padding: const EdgeInsets.only(right: 16.0),
                    color: Colors.redAccent,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    ref.read(domainsProvider.notifier).remove(domains[index]);
                  },
                  child: ListTile(
                    title: Text(domains[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
