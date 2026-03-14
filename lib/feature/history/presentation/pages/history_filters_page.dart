import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../contracts/domain/entity/contract.dart';

class HistoryFiltersPage extends StatefulWidget {
  final List<ContractStatus> initialStatuses;

  const HistoryFiltersPage({
    super.key,
    this.initialStatuses = const [],
  });

  @override
  State<HistoryFiltersPage> createState() => _HistoryFiltersPageState();
}

class _HistoryFiltersPageState extends State<HistoryFiltersPage> {
  late List<ContractStatus> selectedStatuses;

  @override
  void initState() {
    super.initState();
    selectedStatuses = List.from(widget.initialStatuses);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.filters,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.status,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 40,
              runSpacing: 16,
              children: [
                _StatusCheckbox(
                  title: l10n.paid,
                  status: ContractStatus.paid,
                  isSelected: selectedStatuses.contains(ContractStatus.paid),
                  onChanged: (val) => _toggleStatus(ContractStatus.paid, val),
                ),
                _StatusCheckbox(
                  title: l10n.rejectedIq,
                  status: ContractStatus.rejectedByIQ,
                  isSelected: selectedStatuses.contains(ContractStatus.rejectedByIQ),
                  onChanged: (val) => _toggleStatus(ContractStatus.rejectedByIQ, val),
                ),
                _StatusCheckbox(
                  title: l10n.inProcess,
                  status: ContractStatus.inProcess,
                  isSelected: selectedStatuses.contains(ContractStatus.inProcess),
                  onChanged: (val) => _toggleStatus(ContractStatus.inProcess, val),
                ),
                _StatusCheckbox(
                  title: l10n.rejectedPayme,
                  status: ContractStatus.rejectedByPayme,
                  isSelected: selectedStatuses.contains(ContractStatus.rejectedByPayme),
                  onChanged: (val) => _toggleStatus(ContractStatus.rejectedByPayme, val),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A795).withOpacity(0.1),
                      foregroundColor: const Color(0xFF00A795),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'statuses': selectedStatuses,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A795),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(l10n.applyFilters),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _toggleStatus(ContractStatus status, bool? val) {
    setState(() {
      if (val == true) {
        selectedStatuses.add(status);
      } else {
        selectedStatuses.remove(status);
      }
    });
  }
}

class _StatusCheckbox extends StatelessWidget {
  final String title;
  final ContractStatus status;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const _StatusCheckbox({
    required this.title,
    required this.status,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: const Color(0xFF4E4E4E)),
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: Colors.white,
              checkColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF4E4E4E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
