import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/utils/error.dart';
import 'package:user/features/home/dummy_data.dart';
import 'order.model.dart';
import 'order.state.dart';
import 'order.repo.dart';
import 'order.constant.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepo _repo;

  OrderCubit({required OrderRepo repo})
      : _repo = repo,
        super(OrderState(
          activeAddress: dummyAddresses.isNotEmpty ? dummyAddresses[0] : null,
          selectedPaymentMethod: dummyPaymentMethods.length > 2 ? dummyPaymentMethods[2] : null,
          cartItems: [
            const CartItemModel(
              id: 'sohan_papdi',
              name: 'Sohan Papdi',
              price: 53,
              imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500',
              sizeInfo: '2 Pieces',
              isVeg: true,
              quantity: 1,
              subItems: [],
            ),
          ],
        ));

  void addItem(CartItemModel item) {
    final newItems = List<CartItemModel>.from(state.cartItems);
    final index = newItems.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      newItems[index] = newItems[index].copyWith(quantity: newItems[index].quantity + 1);
    } else {
      newItems.add(item);
    }
    emit(state.copyWith(cartItems: newItems));
  }

  void updateItemQuantity(String id, int quantity, List<CartSubItem>? subItems) {
    final newItems = List<CartItemModel>.from(state.cartItems);
    final index = newItems.indexWhere((e) => e.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        newItems.removeAt(index);
      } else {
        newItems[index] = newItems[index].copyWith(
          quantity: quantity,
          subItems: subItems ?? newItems[index].subItems,
        );
      }
      emit(state.copyWith(cartItems: newItems));
    }
  }

  void removeItem(String id) {
    final newItems = List<CartItemModel>.from(state.cartItems);
    newItems.removeWhere((e) => e.id == id);
    emit(state.copyWith(cartItems: newItems));
  }

  void removeCartItem(int index) {
    final newItems = List<CartItemModel>.from(state.cartItems);
    newItems.removeAt(index);
    emit(state.copyWith(cartItems: newItems));
  }

  void clearCart() {
    emit(state.copyWith(cartItems: []));
  }

  Future<void> loadLadyluck() async {
    emit(state.copyWith(ladyluckLoadInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getLadyluckSummary(OrderConstants.LADYLUCK_BRANCH_ID);
    result.fold(
      (failure) {
        emit(state.copyWith(ladyluckLoadInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (summary) {
        final selectedId = summary.active_discounts.isNotEmpty ? summary.active_discounts.first.id : '';
        emit(state.copyWith(
          ladyluckSummary: summary,
          selectedLadyluckDiscountId: selectedId,
          ladyluckLoadInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> scratchLadyluckCard() async {
    if (state.ladyluckSummary.available_scratch_cards.isEmpty) {
      return;
    }
    final scratchCard = state.ladyluckSummary.available_scratch_cards.first;
    emit(state.copyWith(ladyluckScratchInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.scratchLadyluckCard(OrderConstants.LADYLUCK_BRANCH_ID, scratchCard.id);
    await result.fold<Future<void>>(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(ladyluckScratchInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (discount) async {
        emit(state.copyWith(
          selectedLadyluckDiscountId: discount.id,
          ladyluckScratchInfo: const OperationInfo(status: OperationStatus.success),
        ));
        await loadLadyluck();
      },
    );
  }

  void toggleJioSaavn() {
    emit(state.copyWith(jioSaavnAdded: !state.jioSaavnAdded));
  }

  void toggleGold() {
    emit(state.copyWith(goldApplied: !state.goldApplied));
  }

  void setActiveAddress(CartAddress address) {
    emit(state.copyWith(activeAddress: address));
  }

  void setSelectedPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  Future<void> submitOrder() async {
    if (state.cartItems.isEmpty) {
      Fluttertoast.showToast(msg: OrderMessages.CART_EMPTY);
      return;
    }

    emit(state.copyWith(placeOrderInfo: const OperationInfo(status: OperationStatus.loading)));

    final request = CreateOrderRequest(
      orderType: OrderConstants.ORDER_TYPE_DELIVERY,
      branchId: OrderConstants.LADYLUCK_BRANCH_ID,
      finalPayingPrice: state.grandTotal,
      ladyluckDiscountId: state.ladyluckDiscountAmount > 0 ? state.activeLadyluckDiscount?.id : null,
      items: state.cartItems.map((item) {
        return CreateOrderItemRequest(
          menuItemId: item.id,
          quantity: item.quantity,
          notes: null,
        );
      }).toList(),
    );

    final result = await _repo.placeOrder(request);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(placeOrderInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: OrderMessages.ORDER_SUCCESS);
        emit(state.copyWith(
          placeOrderInfo: const OperationInfo(status: OperationStatus.success),
          cartItems: [],
        ));
      },
    );
  }
}

