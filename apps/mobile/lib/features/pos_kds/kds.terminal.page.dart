import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/pos_kds/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/kitchen_order_ticket.model.dart';
import 'package:mobile/utils/error.dart';

class KdsTerminalPage extends StatefulWidget {
  const KdsTerminalPage({super.key});

  @override
  State<KdsTerminalPage> createState() => _KdsTerminalPageState();
}

class _KdsTerminalPageState extends State<KdsTerminalPage> {
  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listKOTs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212), // High contrast dark mode for kitchen
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(PosConstant.KDS_TITLE, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.primaryGreen,
            indicatorWeight: 4,
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
            tabs: const [
              Tab(text: 'NEW (2)'),
              Tab(text: 'PREPARING (1)'),
              Tab(text: 'READY (0)'),
            ],
          ),
        ),
        body: BlocBuilder<PosKdsCubit, PosKdsState>(
          builder: (context, state) {
            if (state.loadKotsInfo.status == OperationStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final newKots = state.kots.where((k) => k.status == 'PENDING').toList();
            final prepKots = state.kots.where((k) => k.status == 'PREPARING').toList();
            final readyKots = state.kots.where((k) => k.status == 'COMPLETED').toList();

            return TabBarView(
              children: [
                // NEW TAB
                newKots.isEmpty ? _buildEmpty('No new orders.') : ListView(
                  padding: EdgeInsets.all(16.w),
                  children: newKots.map((k) => _buildModernKotCard(
                    k,
                    Colors.redAccent,
                    'Start Preparing',
                    () => context.read<PosKdsCubit>().updateKOTStatus(k.id, 'PREPARING'),
                  )).toList(),
                ),
                // PREPARING TAB
                prepKots.isEmpty ? _buildEmpty('No orders preparing.') : ListView(
                  padding: EdgeInsets.all(16.w),
                  children: prepKots.map((k) => _buildModernKotCard(
                    k,
                    Colors.orangeAccent,
                    'Mark Ready',
                    () => context.read<PosKdsCubit>().updateKOTStatus(k.id, 'COMPLETED'),
                  )).toList(),
                ),
                // READY TAB
                readyKots.isEmpty ? _buildEmpty('No orders waiting for pickup.') : ListView(
                  padding: EdgeInsets.all(16.w),
                  children: readyKots.map((k) => _buildModernKotCard(
                    k,
                    Colors.green,
                    'Clear',
                    () => context.read<PosKdsCubit>().updateKOTStatus(k.id, 'CLEARED'),
                  )).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty(String text) {
    return Center(
      child: Text(text, style: TextStyle(color: Colors.white54, fontSize: 16.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildModernKotCard(KitchenOrderTicketModel kot, Color accentColor, String actionText, VoidCallback onAction) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              border: Border(bottom: BorderSide(color: accentColor.withOpacity(0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${kot.order_id}', style: TextStyle(color: accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900)),
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.white54, size: 16.w),
                    SizedBox(width: 4.w),
                    Text('Just now', style: TextStyle(color: Colors.white54, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // Items
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w900)),
                      SizedBox(width: 12.w),
                      Expanded(child: Text('Items for ${kot.order_id}', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w800))),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Action Button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(actionText, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w900)),
            ),
          )
        ],
      ),
    );
  }
}
