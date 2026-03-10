import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ibilling_test/feature/contracts/presentation/bloc/contracts_bloc.dart';
import 'package:ibilling_test/feature/contracts/presentation/bloc/contracts_event.dart';
import 'package:ibilling_test/feature/contracts/presentation/bloc/contracts_state.dart';
import 'package:ibilling_test/feature/contracts/presentation/widgets/contract_item.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  DateTime selectedDate = DateTime.now();
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContractsBloc>().add(FetchContractsRequested());
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
        children: [
          if (!isSearching) ...[
            _buildCalendarHeader(l10n),
            _buildCalendarStrip(l10n),
          ],
          Expanded(
            child: BlocBuilder<ContractsBloc, ContractsState>(
              builder: (context, state) {
                if (state.status == ContractsStatus.loading && state.contracts.isEmpty) {
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
                } else if (state.status == ContractsStatus.failure && state.contracts.isEmpty) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Error fetching contracts',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  );
                } else if (state.contracts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/no contracts/no_contract.svg',
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

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.contracts.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == state.contracts.length) {
                      if (state.hasReachedMax) {
                        return const SizedBox.shrink();
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: state.status == ContractsStatus.loadingMore
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: 106,
                                  height: 37,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<ContractsBloc>()
                                          .add(LoadMoreContractsRequested());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      l10n.loadMore,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }
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
                setState(() {
                  isSearching = false;
                  _searchController.clear();
                  context.read<ContractsBloc>().add(FetchContractsRequested());
                });
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
                context.read<ContractsBloc>().add(FilterContractsRequested(query: value));
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
                  l10n.contracts,
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
            icon: const Icon(Icons.tune, color: Colors.white),
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
              context.read<ContractsBloc>().add(FilterContractsRequested(query: ''));
            },
          ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildCalendarHeader(AppLocalizations l10n) {
    final months = [
      l10n.january, l10n.february, l10n.march, l10n.april, l10n.may, l10n.june,
      l10n.july, l10n.august, l10n.september, l10n.october, l10n.november, l10n.december
    ];
    return Container(
      color: const Color(0xFF141416),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${months[selectedDate.month - 1]}, ${selectedDate.year}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip(AppLocalizations l10n) {
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final weekdays = [
      l10n.monday, l10n.tuesday, l10n.wednesday, l10n.thursday,
      l10n.friday, l10n.saturday, l10n.sunday
    ];

    return Container(
      color: const Color(0xFF141416),
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(selectedDate.year, selectedDate.month, day);
          final weekday = weekdays[(date.weekday - 1) % 7];
          final isSelected = day == selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
              context.read<ContractsBloc>().add(
                FilterContractsRequested(
                  fromDate: DateTime(date.year, date.month, date.day),
                  toDate: DateTime(date.year, date.month, date.day, 23, 59, 59),
                ),
              );
            },
            child: Container(
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      decoration: isSelected ? TextDecoration.underline : null,
                      decorationColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 12,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
