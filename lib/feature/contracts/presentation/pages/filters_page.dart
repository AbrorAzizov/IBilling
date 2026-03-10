import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entity/contract.dart';

class FiltersPage extends StatefulWidget {
  final List<ContractStatus> initialStatuses;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;

  const FiltersPage({
    super.key,
    this.initialStatuses = const [],
    this.initialFromDate,
    this.initialToDate,
  });

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late List<ContractStatus> selectedStatuses;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    selectedStatuses = List.from(widget.initialStatuses);
    fromDate = widget.initialFromDate;
    toDate = widget.initialToDate;
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
            const SizedBox(height: 32),
            Text(
              l10n.date,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateSelector(
                    value: fromDate,
                    hint: '16.02.2021',
                    onTap: () => _selectDate(true),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('-', style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  child: _DateSelector(
                    value: toDate,
                    hint: l10n.to,
                    onTap: () => _selectDate(false),
                  ),
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
                        'fromDate': fromDate,
                        'toDate': toDate,
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

  Future<void> _selectDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
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

class _DateSelector extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final VoidCallback onTap;

  const _DateSelector({
    this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null
                  ? '${value!.day}.${value!.month}.${value!.year}'
                  : hint,
              style: TextStyle(
                color: value != null ? Colors.white : const Color(0xFF4E4E4E),
                fontSize: 14,
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color(0xFF4E4E4E),
            ),
          ],
        ),
      ),
    );
  }
}
