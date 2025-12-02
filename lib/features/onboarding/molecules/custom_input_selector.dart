import 'package:flutter/material.dart';
import '../atoms/input_field.dart';
import '../atoms/primary_button.dart';
import 'package:escape/theme/app_constants.dart';

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
    final exoText = (TextStyle style) => style.copyWith(fontFamily: 'Exo');

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟢 Title & Subtitle Centered
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: exoText(
                    Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppConstants.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: exoText(
                    Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppConstants.darkGray.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 🟡 Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟢 Predefined options
                  Text(
                    'Choose from common options:',
                    style: exoText(
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.predefinedItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCheckboxItem(item),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ✨ Custom items section
                  Text(
                    'Add your own:',
                    style: exoText(
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: _customInputController,
                          hintText: widget.hintText,
                          onSubmitted: (_) => _addCustomItem(),
                        ),
                      ),
                      const SizedBox(width: 10),
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

                  // 🧩 Custom items display
                  if (_customItems.isNotEmpty) ...[
                    Text(
                      'Your custom items:',
                      style: exoText(
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _customItems
                          .map((item) => _buildCustomItemChip(item))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 🔴 Error
          if (widget.showError && _selectedItems.isEmpty && _customItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: Text(
                'Please select at least one option or add your own',
                textAlign: TextAlign.center,
                style: exoText(
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppConstants.errorRed,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String item) {
    final isSelected = _selectedItems.contains(item);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected
            ? AppConstants.primaryGreen.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppConstants.primaryGreen
              : AppConstants.mediumGray.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _toggleItem(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (isSelected)
                Image.asset(
                  'assets/checked.png',
                  width: 28,
                  height: 28,
                  color: AppConstants.primaryGreen,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: AppConstants.darkGray,
                  size: 28,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontFamily: 'Exo',
                    fontSize: 18,
                    color: isSelected
                        ? AppConstants.primaryGreen
                        : AppConstants.darkGray,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
        color: AppConstants.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryGreen.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item,
            style: TextStyle(
              fontFamily: 'Exo',
              color: AppConstants.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeCustomItem(item),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customInputController.dispose();
    super.dispose();
  }
}
