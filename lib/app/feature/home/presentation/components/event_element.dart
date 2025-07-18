import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/event.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class EventPanelList extends StatefulWidget {
  const EventPanelList({super.key, required this.events});

  final List<Event> events;

  @override
  State<EventPanelList> createState() => _EventPanelListState();
}

class _EventPanelListState extends State<EventPanelList> {
  late List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List.generate(widget.events.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(child: _buildPanel()));
  }

  Widget _buildPanel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        children: widget.events.asMap().entries.map<Widget>((entry) {
          int index = entry.key;
          Event event = entry.value;
          return Container(
            decoration: BoxDecoration(
              color: AppColors.primary_light,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  expanded[index] = !expanded[index];
                });
              },
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    color: AppColors.palette_primary,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              event.imageFileName,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          H1(event.title),
                        ],
                      ),
                    ),
                  ),
                  // Expandable Body
                  if (expanded[index])
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary_light,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (event.description.isNotEmpty) ...[
                            const H3(
                              'Descrizione:',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.description,
                              style: AppTextStyles.labelOnPaletteLight,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (event.program.isNotEmpty) ...[
                            const H3(
                              'Programma:',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.program,
                              style: AppTextStyles.labelOnPaletteLight,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (event.contacts.isNotEmpty) ...[
                            const H3(
                              'Contatti:',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.contacts,
                              style: AppTextStyles.labelOnPaletteLight,
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
