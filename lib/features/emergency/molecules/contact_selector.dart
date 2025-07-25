import 'package:flutter/material.dart';
import '../atoms/emergency_button.dart';

class ContactSelector extends StatelessWidget {
  final List<ContactOption> contacts;
  final ValueChanged<ContactOption>? onContactSelected;
  final String title;
  final String subtitle;

  const ContactSelector({
    super.key,
    required this.contacts,
    this.onContactSelected,
    this.title = 'Emergency Contacts',
    this.subtitle = 'Select a trusted contact to reach out to',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contacts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return EmergencyButton(
              text: contact.name,
              icon: contact.icon,
              backgroundColor: Colors.white,
              foregroundColor: Colors.redAccent,
              onPressed: () => onContactSelected?.call(contact),
              width: double.infinity,
            );
          },
        ),
      ],
    );
  }
}

class ContactOption {
  final String name;
  final IconData icon;
  final String? phoneNumber;
  final String? emailAddress;

  const ContactOption({
    required this.name,
    required this.icon,
    this.phoneNumber,
    this.emailAddress,
  });
}
