import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/features/business/models/branch_model.dart';
import 'package:mobile/features/business/models/business_model.dart';
import 'package:mobile/utils/error.dart';

class FindBusinessPage extends StatefulWidget {
  const FindBusinessPage({super.key});

  @override
  State<FindBusinessPage> createState() => _FindBusinessPageState();
}

class _FindBusinessPageState extends State<FindBusinessPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listenWhen: (previous, current) =>
          previous.joinRequestInfo.status != current.joinRequestInfo.status,
      listener: (context, state) {
        if (state.joinRequestInfo.status == OperationStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.pendingJoin);
        }

        if (state.joinRequestInfo.status == OperationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.joinRequestInfo.error?.message ??
                    BusinessConstants.requiredFieldMessage,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSearching = state.searchInfo.status == OperationStatus.loading;
        final hasSearched = state.searchInfo.status == OperationStatus.success;

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          appBar: AppBar(
            backgroundColor: AppColors.pureWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.deepOnyx),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              BusinessConstants.findBusiness,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    BusinessConstants.findBusinessTitle,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    BusinessConstants.findBusinessSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 28.h),
                  AppInput(
                    hintText: BusinessConstants.searchBusinessHint,
                    controller: _searchController,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primaryIndigo,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    text: isSearching
                        ? BusinessConstants.searchBusiness
                        : BusinessConstants.searchBusiness,
                    onPressed: isSearching ? () {} : _searchBusinesses,
                  ),
                  SizedBox(height: 24.h),
                  if (isSearching)
                    const Center(child: CircularProgressIndicator())
                  else if (hasSearched && state.searchResults.isEmpty)
                    _EmptyMessage(message: BusinessConstants.noBusinessesFound)
                  else
                    ...state.searchResults.map(
                      (business) => _BusinessResultCard(
                        business: business,
                        branches:
                            state.branchesByBusiness[business.id] ?? const [],
                        branchesLoaded: state.branchesByBusiness.containsKey(
                          business.id,
                        ),
                        isBranchLoading:
                            state.branchInfo.status == OperationStatus.loading,
                        isRequesting:
                            state.joinRequestInfo.status ==
                            OperationStatus.loading,
                        onLoadBranches: () {
                          context.read<BusinessCubit>().getBranches(
                            business.id,
                          );
                        },
                        onRequest: (branch) {
                          context.read<BusinessCubit>().requestToJoin(
                            branch.id,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _searchBusinesses() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(BusinessConstants.enterBusinessName)),
      );
      return;
    }

    context.read<BusinessCubit>().searchBusinesses(query);
  }
}

class _BusinessResultCard extends StatelessWidget {
  final BusinessModel business;
  final List<BranchModel> branches;
  final bool branchesLoaded;
  final bool isBranchLoading;
  final bool isRequesting;
  final VoidCallback onLoadBranches;
  final ValueChanged<BranchModel> onRequest;

  const _BusinessResultCard({
    required this.business,
    required this.branches,
    required this.branchesLoaded,
    required this.isBranchLoading,
    required this.isRequesting,
    required this.onLoadBranches,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storefront,
                color: AppColors.primaryIndigo,
                size: 28.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      business.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (branchesLoaded && branches.isEmpty)
            _EmptyMessage(message: BusinessConstants.noBranchesFound)
          else if (branches.isEmpty)
            AppButton(
              text: isBranchLoading
                  ? BusinessConstants.selectBranch
                  : BusinessConstants.selectBranch,
              onPressed: isBranchLoading ? () {} : onLoadBranches,
              backgroundColor: AppColors.deepOnyx,
            )
          else
            Column(
              children: branches
                  .map(
                    (branch) => _BranchJoinTile(
                      branch: branch,
                      isRequesting: isRequesting,
                      onRequest: () => onRequest(branch),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _BranchJoinTile extends StatelessWidget {
  final BranchModel branch;
  final bool isRequesting;
  final VoidCallback onRequest;

  const _BranchJoinTile({
    required this.branch,
    required this.isRequesting,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  branch.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          AppButton(
            text: isRequesting
                ? BusinessConstants.requestingJoin
                : BusinessConstants.requestToJoin,
            onPressed: isRequesting ? () {} : onRequest,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
