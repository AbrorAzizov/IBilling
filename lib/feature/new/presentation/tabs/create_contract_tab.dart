import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../contracts/presentation/widgets/custom_dropdown.dart';
import '../../../contracts/presentation/widgets/custom_field.dart';
import '../../../contracts/presentation/widgets/primary_button.dart';
import '../../domain/entity/contract.dart';
import '../bloc/create_bloc.dart';
import '../bloc/create_event.dart';
import '../bloc/create_state.dart';

class CreateContractTab extends StatefulWidget {
  const CreateContractTab({super.key});

  @override
  State<CreateContractTab> createState() => _CreateContractTabState();
}

class _CreateContractTabState extends State<CreateContractTab> {
  ContractPersonType? selectedPersonType;
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final innController = TextEditingController();
  ContractStatus? selectedStatus;

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    innController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CreateBloc, CreateState>(
      listener: (context, state) {
        if (state.status == CreateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contract created successfully!')),
          );
          Navigator.of(context).pop();
        } else if (state.status == CreateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error creating contract')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownField(
              label: l10n.entity,
              value: selectedPersonType == ContractPersonType.physical
                  ? l10n.individual
                  : selectedPersonType == ContractPersonType.legal
                      ? l10n.legalEntity
                      : null,
              onChanged: (value) {
                setState(() {
                  if (value == l10n.individual) {
                    selectedPersonType = ContractPersonType.physical;
                  } else if (value == l10n.legalEntity) {
                    selectedPersonType = ContractPersonType.legal;
                  }
                });
              },
              items: [
                l10n.individual,
                l10n.legalEntity,
              ],
            ),
            const SizedBox(height: 16),
            CustomField(
              label: l10n.fullName,
              controller: fullNameController,
            ),
            const SizedBox(height: 16),
            CustomField(
              label: l10n.organizationAddress,
              controller: addressController,
            ),
            const SizedBox(height: 16),
            CustomField(
              label: l10n.inn,
              controller: innController,
            ),
            const SizedBox(height: 16),
            DropdownField(
              label: l10n.contractStatus,
              value: selectedStatus == ContractStatus.paid
                  ? l10n.paid
                  : selectedStatus == ContractStatus.inProcess
                      ? l10n.inProcess
                      : selectedStatus == ContractStatus.rejectedByPayme
                          ? l10n.rejectedPayme
                          : selectedStatus == ContractStatus.rejectedByIQ
                              ? l10n.rejectedIq
                              : null,
              onChanged: (value) {
                setState(() {
                  if (value == l10n.paid) {
                    selectedStatus = ContractStatus.paid;
                  } else if (value == l10n.inProcess) {
                    selectedStatus = ContractStatus.inProcess;
                  } else if (value == l10n.rejectedPayme) {
                    selectedStatus = ContractStatus.rejectedByPayme;
                  } else if (value == l10n.rejectedIq) {
                    selectedStatus = ContractStatus.rejectedByIQ;
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
                  title: l10n.saveContract,
                  onPressed: state.status == CreateStatus.loading
                      ? null
                      : () {
                          if (selectedPersonType != null &&
                              selectedStatus != null) {
                            final contract = Contract(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              personType: selectedPersonType!,
                              fullName: fullNameController.text,
                              address: addressController.text,
                              inn: innController.text,
                              status: selectedStatus!,
                              createdAt: DateTime.now(),
                            );
                            context.read<CreateBloc>().add(
                                  CreateContractRequested(contract),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')),
                            );
                          }
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
