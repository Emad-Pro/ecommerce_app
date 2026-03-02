import 'package:ecommerce_app/core/states/request_state.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final AppRequestState requestState;
  final List<CartItemEntity> cartItems;
  final String? message;

  CartState({this.requestState = AppRequestState.loading, this.cartItems = const [], this.message});

  CartState copyWith({AppRequestState? requestState, List<CartItemEntity>? cartItems, String? message}) {
    return CartState(
      requestState: requestState ?? this.requestState,
      cartItems: cartItems ?? this.cartItems,
      message: message,
    );
  }

  @override
  List<Object?> get props => [requestState, cartItems, message];
}
