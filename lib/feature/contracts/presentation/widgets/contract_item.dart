import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_paths.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entity/contract.dart';
import '../bloc/contracts_bloc.dart';

class ContractItem extends StatelessWidget {
  final Contract contract;

  const ContractItem({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        final bloc = context.read<ContractsBloc>();
        context.push(RoutePaths.contractDetails, extra: {
          'contract': contract,
          'bloc': bloc,
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '№ ${contract.id}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(contract.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusText(l10n, contract.status),
                    style: TextStyle(
                      color: _getStatusColor(contract.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(label: 'Fish:', value: contract.fullName),
            _InfoRow(label: 'Amount:', value: 'N/A'),
            _InfoRow(label: 'Last invoice:', value: '№ 123'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoRow(
                  label: 'Number of Invoices:',
                  value: '4',
                ),
                Text(
                  '${contract.createdAt.day}.${contract.createdAt.month}.${contract.createdAt.year}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Color _getStatusColor(ContractStatus status) {
    switch (status) {
      case ContractStatus.paid:
        return AppColors.primary;
      case ContractStatus.inProcess:
        return Colors.orange;
      case ContractStatus.rejectedByPayme:
      case ContractStatus.rejectedByIQ:
        return Colors.red;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.white, fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
