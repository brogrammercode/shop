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

  void removeCartItem(int index) {
    final newItems = List<CartItemModel>.from(state.cartItems);
    newItems.removeAt(index);
    emit(state.copyWith(cartItems: newItems));
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

