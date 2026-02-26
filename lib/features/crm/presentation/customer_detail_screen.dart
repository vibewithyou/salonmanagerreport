import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/customer_profiles_repository.dart';
import '../data/customer_notes_repository.dart';
import '../../../services/supabase_service.dart';


final customerProfilesRepositoryProvider = Provider<CustomerProfilesRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return CustomerProfilesRepository(supabaseService.client);
});
final customerNotesRepositoryProvider = Provider<CustomerNotesRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return CustomerNotesRepository(supabaseService.client);
});

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final String customerId;
  final String salonId;
  final String currentUserId;

  const CustomerDetailScreen({
    required this.customerId,
    required this.salonId,
    required this.currentUserId,
    super.key,
  });

  @override
  ConsumerState<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  int _selectedTab = 0;
  final TextEditingController _noteController = TextEditingController();
  bool _isAddingNote = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProfilesRepo = ref.watch(customerProfilesRepositoryProvider);
    final notesRepo = ref.watch(customerNotesRepositoryProvider);
    // Now using real providers for CRM

    return Scaffold(
      appBar: AppBar(
        title: Text('Kundenprofil'),
      ),
      body: Column(
        children: [
          TabBar(
            onTap: (i) => setState(() => _selectedTab = i),
            tabs: const [
              Tab(text: 'Historie'),
              Tab(text: 'Notizen'),
              Tab(text: 'Loyalty'),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                // Historie Tab
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: customerProfilesRepo.listCustomerBookings(widget.salonId, widget.customerId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final bookings = snapshot.data!;
                    if (bookings.isEmpty) {
                      return Center(child: Text('Keine Buchungen gefunden'));
                    }
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, i) {
                        final booking = bookings[i];
                        return ListTile(
                          title: Text('Buchung: ' + (booking['service_name'] ?? '')), // adjust field as needed
                          subtitle: Text('Datum: ' + (booking['created_at'] ?? '')),
                        );
                      },
                    );
                  },
                ),
                // Notizen Tab
                Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: notesRepo.getCustomerNotes(widget.customerId, widget.salonId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const CircularProgressIndicator();
                          final notes = snapshot.data!;
                          return ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, i) => ListTile(
                              title: Text(notes[i].note),
                              subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(notes[i].createdAt)),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isAddingNote)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _noteController,
                                decoration: const InputDecoration(hintText: 'Notiz eingeben'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () async {
                                await notesRepo.addNote(
                                  salonId: widget.salonId,
                                  customerId: widget.customerId,
                                  createdBy: widget.currentUserId,
                                  note: _noteController.text,
                                );
                                setState(() => _isAddingNote = false);
                                _noteController.clear();
                                setState(() {}); // reload notes
                              },
                            ),
                          ],
                        ),
                      ),
                    if (!_isAddingNote)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isAddingNote = true),
                          child: const Text('Notiz hinzufügen'),
                        ),
                      ),
                  ],
                ),
                // Loyalty Tab
                Center(child: Text('Loyalty (Platzhalter)')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
