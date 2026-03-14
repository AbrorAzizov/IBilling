import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../../history/presentation/bloc/history_state.dart';
import '../../../new/domain/entity/contract.dart';
import '../bloc/contracts_bloc.dart';
import '../bloc/contracts_event.dart';
import '../bloc/contracts_state.dart';
import '../widgets/contract_item.dart';

class ContractDetailsPage extends StatelessWidget {
  final Contract contract;

  const ContractDetailsPage({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Determine which bloc is being used (ContractsBloc or HistoryBloc)
    final contractsBloc = _getBloc<ContractsBloc>(context);
    final historyBloc = _getBloc<HistoryBloc>(context);

    return MultiBlocListener(
      listeners: [
        if (contractsBloc != null)
          BlocListener<ContractsBloc, ContractsState>(
            listener: (context, state) {
              if (state.status == ContractsStatus.success &&
                  !state.contracts.any((c) => c.id == contract.id)) {
                _onDeleteSuccess(context);
              }
            },
          ),
        if (historyBloc != null)
          BlocListener<HistoryBloc, HistoryState>(
            listener: (context, state) {
              if (state.status == HistoryStatus.success &&
                  !state.contracts.any((c) => c.id == contract.id)) {
                _onDeleteSuccess(context);
              }
            },
          ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: const Color(0xFF141416),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              const Icon(Icons.description_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                '№ ${contract.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          actions: [
            if (contractsBloc != null)
              BlocBuilder<ContractsBloc, ContractsState>(
                builder: (context, state) {
                  final isSaved = state.savedContracts.any((c) => c.id == contract.id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.read<ContractsBloc>().add(ToggleSaveContractRequested(contract));
                    },
                  );
                },
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: "Fisher's full name:", value: contract.fullName),
                    _DetailRow(
                      label: 'Status of the contract:',
                      value: _getStatusText(l10n, contract.status),
                      isStatus: true,
                    ),
                    _DetailRow(label: 'Amount:', value: '1,200,000 UZS'),
                    _DetailRow(label: 'Last invoice:', value: '№ 156'),
                    _DetailRow(label: 'Number of invoices:', value: '6'),
                    _DetailRow(
                      label: 'Address of the organization:',
                      value: contract.address,
                    ),
                    _DetailRow(label: 'ITN/IEC of the organization:', value: contract.inn),
                    _DetailRow(
                      label: 'Created at:',
                      value:
                          '${contract.createdAt.hour}:${contract.createdAt.minute}, ${contract.createdAt.day} ${_getMonthName(l10n, contract.createdAt.month)}, ${contract.createdAt.year}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (contractsBloc != null) {
                          contractsBloc.add(DeleteContractRequested(contract.id));
                        } else if (historyBloc != null) {
                          historyBloc.add(DeleteHistoryContractRequested(contract.id));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4949).withOpacity(0.1),
                        foregroundColor: const Color(0xFFFF4949),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Delete contract', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(RoutePaths.contractCreate);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Create contract', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Other contracts with\n${contract.fullName}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ContractItem(contract: contract),
              const SizedBox(height: 12),
              ContractItem(contract: contract),
            ],
          ),
        ),
      ),
    );
  }

  T? _getBloc<T extends StateStreamableSource<Object?>>(BuildContext context) {
    try {
      return context.read<T>();
    } catch (_) {
      return null;
    }
  }

  void _onDeleteSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contract deleted successfully')),
    );
    if (context.canPop()) {
      context.pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  String _getStatusText(AppLocalizations l10n, ContractStatus status) {
    switch (status) {
      case ContractStatus.paid:
        return l10n.paid;
      case ContractStatus.inProcess:
        return l10n.inProcess;
      case ContractStatus.rejectedByPayme:
        return l10n.rejectedPayme;
      case ContractStatus.rejectedByIQ:
        return l10n.rejectedIq;
    }
  }

  String _getMonthName(AppLocalizations l10n, int month) {
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december
    ];
    return months[month - 1];
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStatus;

  const _DetailRow({required this.label, required this.value, this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isStatus ? AppColors.primary : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: isStatus ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
