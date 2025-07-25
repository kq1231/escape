import 'package:flutter/material.dart';
import '../atoms/input_field.dart';
import '../atoms/primary_button.dart';

class CustomInputSelector extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> predefinedItems;
  final List<String> selectedItems;
  final List<String> customItems;
  final ValueChanged<List<String>> onSelectedChanged;
  final ValueChanged<List<String>> onCustomChanged;
  final String hintText;
  final String addButtonText;
  final bool showError;

  const CustomInputSelector({
    super.key,
    required this.title,
    required this.subtitle,
    required this.predefinedItems,
    required this.selectedItems,
    required this.customItems,
    required this.onSelectedChanged,
    required this.onCustomChanged,
    required this.hintText,
    required this.addButtonText,
    this.showError = false,
  });

  @override
  State<CustomInputSelector> createState() => _CustomInputSelectorState();
}

class _CustomInputSelectorState extends State<CustomInputSelector> {
  final TextEditingController _customInputController = TextEditingController();
  late List<String> _selectedItems;
  late List<String> _customItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
    _customItems = List.from(widget.customItems);
  }

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      widget.onSelectedChanged(_selectedItems);
    });
  }

  void _addCustomItem() {
    final text = _customInputController.text.trim();
    if (text.isNotEmpty && !_customItems.contains(text)) {
      setState(() {
        _customItems.add(text);
        _customInputController.clear();
        widget.onCustomChanged(_customItems);
      });
    }
  }

  void _removeCustomItem(String item) {
    setState(() {
      _customItems.remove(item);
      widget.onCustomChanged(_customItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Single scrollable container for all content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Predefined items section
                Text(
                  'Choose from common options:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...widget.predefinedItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildCheckboxItem(item),
                  ),
                ),

                const SizedBox(height: 24),

                // Custom items section
                Text(
                  'Add your own:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Input field for custom items
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: _customInputController,
                        hintText: widget.hintText,
                        onSubmitted: (_) => _addCustomItem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PrimaryButton(
                      text: widget.addButtonText,
                      onPressed: _addCustomItem,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Display custom items
                if (_customItems.isNotEmpty) ...[
                  Text(
                    'Your custom items:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  ..._customItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildCustomItemChip(item),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        if (widget.showError && _selectedItems.isEmpty && _customItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Text(
              'Please select at least one option or add your own',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCheckboxItem(String item) {
    final isSelected = _selectedItems.contains(item);
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _toggleItem(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomItemChip(String item) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _removeCustomItem(item),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customInputController.dispose();
    super.dispose();
  }
}
