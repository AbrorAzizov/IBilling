# SavedBloc - Sorting with Clean Architecture

## Architecture Overview

The SavedBloc follows **Clean Architecture** with proper separation of concerns:

```
Presentation Layer (SavedBloc)
    ↓ (State Management Only)
Domain Layer (GetSavedContractsUseCase)
    ↓ (Business Logic - Sorting)
ContractsBloc (Data Source)
    ↓
Contracts Domain Layer (GetContractsUseCase)
```

## Components

### 1. GetSavedContractsUseCase (Domain Layer - Business Logic)
**File**: `lib/feature/saved/domain/usecases/get_saved_contracts_usecase.dart`

**Responsibility**: **Sorting logic only**
```dart
class GetSavedContractsUseCase {
  GetSavedContractsUseCase();

  /// Sort saved contracts by creation date (newest first)
  List<Contract> getSavedContractsFromList(List<Contract> contracts) {
    final sorted = List.of(contracts);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}
```

### 2. SavedEvent (Presentation Layer)
**File**: `lib/feature/saved/presentation/bloc/saved_event.dart`

**Events**:
- `FetchSavedContractsRequested` - Fetch all saved contracts
- `DeleteSavedContractRequested` - Delete a saved contract
- `RemoveSavedContractRequested` - Remove from saved list

### 3. SavedState (Presentation Layer)
**File**: `lib/feature/saved/presentation/bloc/saved_state.dart`

**State**:
- `status: SavedStatus` - (initial, loading, success, failure)
- `savedContracts: List<Contract>` - Sorted list (newest first)
- `errorMessage: String?` - Error details
- `hasReachedMax: bool` - Not used (removed pagination)

### 4. SavedBloc (Presentation Layer - State Management)
**File**: `lib/feature/saved/presentation/bloc/saved_bloc.dart`

**Responsibilities**:
- ✅ State management ONLY
- ✅ Calls usecase for sorting
- ✅ Emits proper states
- ✅ Listens to ContractsBloc for real-time updates

**Event Handlers**:

1. **`_onFetchSavedContractsRequested()`**
   - Gets saved contracts from ContractsBloc.state
   - Calls usecase to sort
   - Emits sorted contracts

2. **`_onDeleteSavedContractRequested()`**
   - Removes contract from saved list
   - Emits updated state

3. **`_onRemoveSavedContractRequested()`**
   - Removes contract locally
   - Emits updated state

### 5. SavedModule (Dependency Injection)
**File**: `lib/feature/saved/di/saved_module.dart`

```dart
class SavedModule {
  Future<void> register(GetIt sl) async {
    // Use cases - Sorting logic
    sl.registerLazySingleton(() => GetSavedContractsUseCase());

    // BLoCs - State management
    sl.registerFactory(() => SavedBloc(
      getSavedContractsUseCase: sl(),  // Inject sorting usecase
      contractsBloc: sl(),              // Inject data source
    ));
  }
}
```

## Data Flow

```
1. SavedPage loads
    ↓
2. ContractsBloc provides data (contract_page state)
    ↓
3. SavedBloc listens to ContractsBloc changes
    ↓
4. SavedBloc calls SavedContractsFromList() from usecase
    ↓
5. UseCase sorts contracts (newest first)
    ↓
6. SavedBloc emits SavedState with sorted contracts
    ↓
7. SavedPage rebuilds with sorted saved contracts
```

## Clean Architecture Benefits

| Layer | Responsibility | Location |
|-------|----------------|----------|
| **Presentation** | State Management | SavedBloc |
| **Domain** | Business Logic (Sorting) | GetSavedContractsUseCase |
| **Presentation** | UI Display | SavedPage |

### Separation of Concerns:
- ✅ **Sorting logic** in UseCase (Domain layer) - Reusable, testable
- ✅ **State management** in SavedBloc (Presentation layer) - UI logic only
- ✅ **No UI logic** in business logic layer
- ✅ **No business logic** in state management layer

## Comparison with ContractsBloc

| Aspect | ContractsBloc | SavedBloc |
|--------|---------------|-----------|
| **Data Source** | Firebase | ContractsBloc state |
| **Sorting** | In bloc (can move to usecase) | In usecase ✓ |
| **Pagination** | Yes | No |
| **Independence** | Standalone | Dependent on ContractsBloc |
| **Architecture** | Can be improved | Clean ✓ |

## Usage in SavedPage

```dart
@override
void initState() {
  super.initState();
  // Load saved contracts
  context.read<SavedBloc>().add(FetchSavedContractsRequested());
}

@override
Widget build(BuildContext context) {
  return BlocBuilder<SavedBloc, SavedState>(
    builder: (context, state) {
      if (state.status == SavedStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.savedContracts.isEmpty) {
        return const Center(child: Text('No saved contracts'));
      }

      // Contracts are already sorted (newest first) by usecase!
      return ListView.builder(
        itemCount: state.savedContracts.length,
        itemBuilder: (context, index) {
          return ContractItem(
            contract: state.savedContracts[index],
          );
        },
      );
    },
  );
}
```

## Testing Benefits

Easy to test each layer independently:

```dart
// Test sorting in isolation
test('GetSavedContractsUseCase sorts by date', () {
  final usecase = GetSavedContractsUseCase();
  final result = usecase.getSavedContractsFromList(mockContracts);
  expect(result[0].createdAt, greaterThan(result[1].createdAt));
});

// Test bloc state transitions
test('SavedBloc emits sorted contracts', () async {
  final mockUsecase = MockGetSavedContractsUseCase();
  final mockBloc = MockContractsBloc();
  
  final bloc = SavedBloc(
    getSavedContractsUseCase: mockUsecase,
    contractsBloc: mockBloc,
  );

  expectLater(
    bloc.stream,
    emitsInOrder([
      SavedState(status: SavedStatus.loading),
      SavedState(status: SavedStatus.success, savedContracts: sortedList),
    ]),
  );

  bloc.add(FetchSavedContractsRequested());
});
```

## Summary

✅ **Clean Architecture** - Proper layer separation  
✅ **Sorting in UseCase** - Domain layer has business logic  
✅ **State Management in Bloc** - Presentation layer only  
✅ **Testable** - Each layer can be tested independently  
✅ **Maintainable** - Clear responsibilities  
✅ **Just like ContractPage** - Follows same pattern  

The SavedBloc now properly implements Clean Architecture with sorting in the usecase layer! 🎉

