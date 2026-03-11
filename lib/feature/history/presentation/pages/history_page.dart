import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ibilling_test/feature/contracts/presentation/bloc/contracts_bloc.dart';
import 'package:ibilling_test/feature/contracts/presentation/bloc/contracts_state.dart';
import 'package:ibilling_test/feature/contracts/presentation/widgets/contract_item.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF141416),
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/app_bar/Ellipse 13.svg',
              height: 35,
              width: 35,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.history,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/filter/Filter.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
          const VerticalDivider(
            color: Color(0xFF4E4E4E),
            width: 1,
            indent: 15,
            endIndent: 15,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                     _DateSelector(
                        value: fromDate,
                        hint: '16.02.2021',
                        onTap: () => _selectDate(true),
                      ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('-', style: TextStyle(color: Colors.white)),
                    ),

                       _DateSelector(
                        value: toDate,
                        hint: l10n.to,
                        onTap: () => _selectDate(false),
                      ),

                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ContractsBloc, ContractsState>(
              builder: (context, state) {
                // Sorting by date (newest first)
                final sortedContracts = List.from(state.contracts);
                sortedContracts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (sortedContracts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/no contracts/no_contract.svg',
                          width: 80,
                          height: 80,
                        ),

                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedContracts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final contract = sortedContracts[index];
                    return ContractItem(contract: contract);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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
      // Optionally trigger search/filter here
    }
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
        width: 115,
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
                  ? '${value!.day.toString().padLeft(2, '0')}.${value!.month.toString().padLeft(2, '0')}.${value!.year}'
                  : hint,
              style: TextStyle(
                color: value != null ? Colors.white : const Color(0xFF4E4E4E),
                fontSize: 14,
              ),
            ),
            const Icon(
              Icons.calendar_month_sharp,
              size: 16,
              color: Color(0xFF4E4E4E),
            ),
          ],
        ),
      ),
    );
  }
}
