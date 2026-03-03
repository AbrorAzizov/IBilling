import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/primary_button.dart';

class CreateContractTab extends StatelessWidget {
  const CreateContractTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          DropdownField(
            label: l10n.entity,
            value: null,
            onChanged: (value) {},
            items: [
              l10n.individual,
              l10n.legalEntity,
            ],
          ),
          const SizedBox(height: 16),

          CustomField(label: l10n.fullName),
          const SizedBox(height: 16),

          CustomField(label: l10n.organizationAddress),
          const SizedBox(height: 16),

          CustomField(label: l10n.inn),
          const SizedBox(height: 16),

          DropdownField(
            label: l10n.contractStatus,
            value: null,
            onChanged: (value) {},
            items: [
              l10n.paid,
              l10n.inProcess,
              l10n.rejectedPayme,
              l10n.rejectedIq,
            ],
          ),
          const SizedBox(height: 24),

          PrimaryButton(
            title: l10n.saveContract,
            onPressed: () {
              // Save contract logic
            },
          ),
        ],
      ),
    );
  }
}