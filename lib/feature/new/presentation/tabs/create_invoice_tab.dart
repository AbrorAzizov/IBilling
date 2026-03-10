import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibilling_test/feature/shared/widgets/app_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../contracts/presentation/widgets/custom_dropdown.dart';
import '../../../contracts/presentation/widgets/custom_field.dart';
import '../../../contracts/presentation/widgets/primary_button.dart';
import '../../domain/entity/invoice.dart';
import '../bloc/create_bloc.dart';
import '../bloc/create_event.dart';
import '../bloc/create_state.dart';

class CreateInvoiceTab extends StatefulWidget {
  const CreateInvoiceTab({super.key});

  @override
  State<CreateInvoiceTab> createState() => _CreateInvoiceTabState();
}

class _CreateInvoiceTabState extends State<CreateInvoiceTab> {
  final serviceNameController = TextEditingController();
  final amountController = TextEditingController();
  InvoiceStatus? selectedStatus;

  @override
  void dispose() {
    serviceNameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CreateBloc, CreateState>(
      listener: (context, state) {
        if (state.status == CreateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invoice created successfully!')),
          );
          Navigator.of(context).pop();
        } else if (state.status == CreateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error creating invoice'),
            ),
          );
        }
      },
      child: Column(
        children: [
          const CustomAppBar(title: 'New Contract'),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  CustomField(
                    label: l10n.serviceName,
                    controller: serviceNameController,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: l10n.invoiceAmount,
                    controller: amountController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownField(
                    label: l10n.invoiceStatus,
                    value: selectedStatus == InvoiceStatus.paid
                        ? l10n.paid
                        : selectedStatus == InvoiceStatus.pending
                        ? l10n.inProcess
                        : selectedStatus == InvoiceStatus.cancelled
                        ? l10n.rejectedPayme
                        : null,
                    onChanged: (value) {
                      setState(() {
                        if (value == l10n.paid) {
                          selectedStatus = InvoiceStatus.paid;
                        } else if (value == l10n.inProcess) {
                          selectedStatus = InvoiceStatus.pending;
                        } else if (value == l10n.rejectedPayme ||
                            value == l10n.rejectedIq) {
                          selectedStatus = InvoiceStatus.cancelled;
                        }
                      });
                    },
                    items: [
                      l10n.paid,
                      l10n.inProcess,
                      l10n.rejectedPayme,
                      l10n.rejectedIq,
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<CreateBloc, CreateState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        title: l10n.createInvoice,
                        onPressed: state.status == CreateStatus.loading
                            ? null
                            : () {
                                final amount = double.tryParse(
                                  amountController.text,
                                );
                                if (amount != null && selectedStatus != null) {
                                  final invoice = Invoice(
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    title: serviceNameController.text,
                                    amount: amount,
                                    status: selectedStatus!,
                                    createdAt: DateTime.now(),
                                  );
                                  context.read<CreateBloc>().add(
                                    CreateInvoiceRequested(invoice),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill all fields correctly',
                                      ),
                                    ),
                                  );
                                }
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
