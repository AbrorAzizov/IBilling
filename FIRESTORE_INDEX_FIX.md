# Firestore Index Issue - Solution Guide

## Problem
The error you're seeing:
```
[cloud_firestore/failed-precondition] The query requires an index.
```

This occurs when filtering contracts by multiple fields with compound queries (filtering by `status` AND `createdAt` together).

## Root Cause
Firestore requires composite indexes for queries that filter on multiple fields. The current implementation in `ContractsBloc._onFilterContractsRequested()` tries to filter with:
- `status` (IN clause with multiple values)
- `createdAt` (range queries with fromDate and toDate)
- Ordering by `__name__` and `createdAt`

This combination requires a composite index.

## Solution

### Option 1: Create the Index Automatically (Recommended)
1. Click the link provided in the error message - it takes you directly to Firebase Console
2. Review the index configuration
3. Click "Create Index" button
4. Wait for the index to be built (usually takes a few minutes)

Example URL from the error:
```
https://console.firebase.google.com/v1/r/project/first-project-34ce3/firestore/indexes?create_composite=...
```

### Option 2: Create Index Manually in Firebase Console
1. Go to [Firebase Console](https://console.firebase.com)
2. Select your project: `first-project-34ce3`
3. Go to **Firestore Database** → **Indexes** → **Composite Indexes**
4. Click **Create Index**
5. Configure:
   - **Collection ID**: `contracts`
   - **Fields indexed**:
     - `status` (Ascending)
     - `createdAt` (Ascending)
     - `__name__` (Ascending)
   - Click **Create**

### Option 3: Modify Query to Avoid Index (Alternative)
Filter on fewer fields to avoid needing the composite index:
- Remove status filter
- Keep only date range filter
- Apply status filter client-side in code

## SavedBloc Improvements
The `SavedBloc` has been updated to:
✅ **Avoid problematic filters** - Uses data from `ContractsBloc` state instead of calling `filterContracts()`
✅ **Sync automatically** - Listens to `ContractsBloc` changes for real-time updates
✅ **Handle errors gracefully** - Proper try-catch blocks and error messages
✅ **Memory efficient** - No redundant API calls for saved contracts
✅ **Prevent subscription leaks** - Properly cancels subscriptions in `close()`

## After Index Creation
Once the Firestore composite index is built:
1. The filter functionality in `ContractsBloc` will work properly
2. SavedBloc will continue to work without issues (it doesn't use filters)
3. All filtering operations will be fast and reliable

## Index Creation Time
- Usually takes 5-10 minutes
- Check status in Firebase Console → Firestore Database → Indexes
- Once status shows "READY", the filter queries will work

