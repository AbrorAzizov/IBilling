import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/primary_button.dart';

class CreateInvoiceTab extends StatelessWidget {
  const CreateInvoiceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          CustomField(label: l10n.serviceName),
          const SizedBox(height: 16),

          CustomField(label: l10n.invoiceAmount),
          const SizedBox(height: 16),

          DropdownField(
            label: l10n.invoiceStatus,
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
            title: l10n.createInvoice,
            onPressed: () {
              // Save invoice logic
            },
          ),
        ],
      ),
    );
  }
}