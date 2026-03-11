import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../contracts/presentation/bloc/contracts_bloc.dart';
import '../../../contracts/presentation/bloc/contracts_state.dart';
import '../../../contracts/presentation/widgets/contract_item.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

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
      body: BlocBuilder<ContractsBloc, ContractsState>(
        builder: (context, state) {
          if (state.savedContracts.isEmpty) {
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
            itemCount: state.savedContracts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final contract = state.savedContracts[index];
              return ContractItem(contract: contract);
            },
          );
        },
      ),
    );
  }
}
