import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../contracts/presentation/bloc/contracts_bloc.dart';
import '../../../contracts/presentation/pages/filters_page.dart';
import '../../../contracts/presentation/widgets/contract_item.dart';
import '../../../contracts/domain/entity/contract.dart';
import '../bloc/saved_bloc.dart';
import '../bloc/saved_event.dart';
import '../bloc/saved_state.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<ContractStatus> selectedStatuses = [];
  DateTime? filterFromDate;
  DateTime? filterToDate;

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
          Expanded(
            child: BlocBuilder<SavedBloc, SavedState>(
              builder: (context, state) {
                if (state.savedContracts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/no contracts/Bookmark.svg',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No saved contracts',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.savedContracts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final contract = state.savedContracts[index];
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
      backgroundColor: AppColors.secondary,
      elevation: 0,
      titleSpacing: 20,
      leading: isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  _searchController.clear();
                  context.read<SavedBloc>().add(const FetchSavedContractsRequested());
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
                context.read<SavedBloc>().add(
                      FilterSavedContractsRequested(
                        query: value,
                        fromDate: filterFromDate,
                        toDate: filterToDate,
                        statuses: selectedStatuses,
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
                  l10n.saved,
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
                  builder: (context) => FiltersPage(
                    initialStatuses: selectedStatuses,
                    initialFromDate: filterFromDate,
                    initialToDate: filterToDate,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  selectedStatuses = result['statuses'];
                  filterFromDate = result['fromDate'];
                  filterToDate = result['toDate'];
                });
                context.read<SavedBloc>().add(
                      FilterSavedContractsRequested(
                        fromDate: filterFromDate,
                        toDate: filterToDate,
                        statuses: selectedStatuses,
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
              context.read<SavedBloc>().add(
                    const FilterSavedContractsRequested(
                      query: '',
                      fromDate: null,
                      toDate: null,
                      statuses: [],
                    ),
                  );
            },
          ),
        const SizedBox(width: 10),
      ],
    );
  }
}
