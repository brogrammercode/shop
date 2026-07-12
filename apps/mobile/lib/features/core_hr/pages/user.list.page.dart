import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/components/ui/dialog.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/features/core_hr/models/address.model.dart';
import 'package:mobile/features/core_hr/models/user.model.dart';
import 'package:mobile/features/finance/bank_detail.model.dart';
import 'package:mobile/utils/error.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String _deletingUserId = '';

  @override
  void initState() {
    super.initState();
    context.read<CoreHrCubit>().listUsers();
  }

  Future<void> _refresh() async {
    await context.read<CoreHrCubit>().listUsers();
  }

  Future<void> _confirmDelete(UserModel user) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: HrConstant.USER_DELETE_TITLE,
      message: HrConstant.USER_DELETE_MESSAGE,
      confirmText: HrConstant.USER_DELETE_CONFIRM,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) {
      return;
    }
    setState(() => _deletingUserId = user.id);
    await context.read<CoreHrCubit>().deleteUser(user.id);
    if (mounted) {
      setState(() => _deletingUserId = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreHrCubit, CoreHrState>(
      builder: (context, state) {
        final isLoading =
            state.userInfo.status == OperationStatus.loading &&
            state.users.isEmpty;
        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state.users.length),
                Expanded(
                  child: isLoading
                      ? const Center(child: AppLoader(size: 24, strokeWidth: 2))
                      : _buildList(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HrConstant.USER_LIST_TITLE,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _refresh,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: Icon(
                Icons.refresh,
                color: AppColors.primaryGreen,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(CoreHrState state) {
    if (state.users.isEmpty) {
      return AppRefresher(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 240.h),
            Center(
              child: Text(
                HrConstant.USER_LIST_EMPTY,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return AppRefresher(
      onRefresh: _refresh,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 112.h),
        itemCount: state.users.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _buildUserCard(state.users[index]),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    final title = user.name.isNotEmpty ? user.name : HrConstant.UNKNOWN;
    final subtitle = user.phone.isNotEmpty
        ? user.phone
        : user.email.isNotEmpty
        ? user.email
        : user.id;
    final isDeleting = _deletingUserId == user.id;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
          leading: CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.14),
            backgroundImage: user.avatar.isNotEmpty
                ? NetworkImage(user.avatar)
                : null,
            child: user.avatar.isEmpty
                ? Text(
                    title[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryGreen,
                    ),
                  )
                : null,
          ),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: GestureDetector(
            onTap: isDeleting ? null : () => _confirmDelete(user),
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.error.withOpacity(0.32)),
              ),
              child: isDeleting
                  ? const Center(child: AppLoader(size: 16, strokeWidth: 2))
                  : Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 19.w,
                    ),
            ),
          ),
          children: [
            _buildSectionTitle(HrConstant.USER_DETAILS),
            _buildInfoRow(HrConstant.USER_ID, user.id),
            _buildInfoRow(HrConstant.NAME, title),
            _buildInfoRow(HrConstant.PHONE, user.phone),
            _buildInfoRow(HrConstant.EMAIL, user.email),
            _buildInfoRow(HrConstant.STATUS, user.status),
            _buildInfoRow(HrConstant.USER_EMPLOYEE_ID, user.employee),
            _buildInfoRow(HrConstant.BRANCH, user.employee_branch_name),
            _buildInfoRow(HrConstant.ROLE, user.employee_role_name),
            _buildInfoRow(HrConstant.DEPARTMENT, user.employee_department_name),
            _buildInfoRow(HrConstant.POST, user.employee_post_name),
            _buildInfoRow(HrConstant.SHIFT, user.employee_shift_name),
            _buildInfoRow(HrConstant.CREATED, _formatTime(user.created_at)),
            _buildInfoRow(HrConstant.UPDATED, _formatTime(user.updated_at)),
            SizedBox(height: 12.h),
            _buildSectionTitle(HrConstant.USER_ACTIVITY),
            _buildCountGrid(user),
            SizedBox(height: 12.h),
            _buildAddresses(user.addresses),
            _buildBanks(user.bank_details),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textTertiary,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : HrConstant.NOT_AVAILABLE,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountGrid(UserModel user) {
    final items = [
      MapEntry(HrConstant.ORDERS, user.order_count),
      MapEntry(HrConstant.SESSIONS, user.session_count),
      MapEntry(HrConstant.COMPLAINTS, user.complaint_count),
      MapEntry(HrConstant.LOYALTY, user.loyalty_transaction_count),
      MapEntry(HrConstant.DEVICES, user.device_token_count),
      MapEntry(HrConstant.LOGS, user.user_log_count),
    ];
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items
          .map(
            (item) => Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.value.toString(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAddresses(List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(HrConstant.USER_ADDRESSES),
        ...addresses.map(
          (address) => _buildInfoRow(HrConstant.ADDRESS, _addressText(address)),
        ),
      ],
    );
  }

  Widget _buildBanks(List<BankDetailModel> banks) {
    if (banks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(HrConstant.USER_BANK_DETAILS),
        ...banks.map((bank) => _buildInfoRow(HrConstant.BANK, _bankText(bank))),
      ],
    );
  }

  String _addressText(AddressModel address) {
    return [
      address.area,
      address.locality,
      address.city,
      address.state,
      address.pin_code,
      address.country,
    ].where((value) => value.isNotEmpty).join(', ');
  }

  String _bankText(BankDetailModel bank) {
    return [
      bank.bank_name,
      bank.account_name,
      bank.account_number,
      bank.ifsc_code,
    ].where((value) => value.isNotEmpty).join(' | ');
  }

  String _formatTime(String value) {
    if (value.isEmpty) {
      return '';
    }
    try {
      final date = DateTime.parse(value).toLocal();
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return value;
    }
  }
}
