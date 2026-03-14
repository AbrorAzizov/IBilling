import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../contracts/presentation/pages/filters_page.dart';
import '../../../contracts/presentation/widgets/contract_item.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? fromDate;
  DateTime? toDate;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial fetch is handled by router's BlocProvider or we can do it here if needed.
    // Since it's provided in router, we can just ensure it fetches.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryBloc>().add(FetchHistoryRequested());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(l10n),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date filter selectors
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

          // Contract list
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state.status == HistoryStatus.loading) {
                  return Center(
                    child: Text(
                      l10n.loading,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  );
                }

                if (state.status == HistoryStatus.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (state.contracts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/no contracts/no_contract.svg',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noContracts,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                // Sorting is now handled in the UseCase
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.contracts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final contract = state.contracts[index];
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

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: const Color(0xFF141416),
      elevation: 0,
      titleSpacing: 20,
      leading: isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  isSearching = false;
                });
                context.read<HistoryBloc>().add(FetchHistoryRequested());
              },
            )
          : null,
      title: isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                context.read<HistoryBloc>().add(
                      FilterHistoryRequested(
                        query: value,
                        fromDate: fromDate,
                        toDate: toDate,
                      ),
                    );
              },
            )
          : Row(
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
        if (!isSearching) ...[
          IconButton(
            icon: SvgPicture.asset(
              'assets/filter/Filter.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FiltersPage(
                    initialFromDate: fromDate,
                    initialToDate: toDate,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  fromDate = result['fromDate'];
                  toDate = result['toDate'];
                });
                context.read<HistoryBloc>().add(
                      FilterHistoryRequested(
                        fromDate: fromDate,
                        toDate: toDate,
                        query: _searchController.text,
                      ),
                    );
              }
            },
          ),
          const VerticalDivider(
            color: Color(0xFF4E4E4E),
            width: 1,
            indent: 15,
            endIndent: 15,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
          ),
        ] else
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              _searchController.clear();
              context.read<HistoryBloc>().add(
                    FilterHistoryRequested(
                      query: '',
                      fromDate: fromDate,
                      toDate: toDate,
                    ),
                  );
            },
          ),
        const SizedBox(width: 10),
      ],
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
      context.read<HistoryBloc>().add(
            FilterHistoryRequested(
              fromDate: fromDate,
              toDate: toDate,
              query: _searchController.text,
            ),
          );
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
