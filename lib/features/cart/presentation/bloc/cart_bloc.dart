import 'dart:async';
import 'package:ecommerce_app/features/cart/domain/use_case/add_cart_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/use_case/clear_cart_item_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/use_case/decrement_cart_item_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/use_case/remove_from_cart_usecase.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/states/request_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final DecrementCartItemUseCase decrementCartItemUseCase;
  final ClearCartItemUseCase clearCartItemUseCase;
  CartBloc({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.decrementCartItemUseCase,
    required this.clearCartItemUseCase,
  }) : super(CartState()) {
    on<GetCartEvent>(_onGetCart);
    on<AddItemToCartEvent>(_onAddToCart);
    on<RemoveItemFromCartEvent>(_onRemoveFromCart);
    on<DecrementCartItemEvent>(_onDecrementCartItem);
    on<IncrementCartItemEvent>(_onIncrementCartItem);
    on<ClearCartEvent>((event, emit) async {
      await clearCartItemUseCase();
      emit(state.copyWith(cartItems: []));
    });
  }

  FutureOr<void> _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(requestState: AppRequestState.loading));
    final result = await getCartItemsUseCase.call();

    result.fold(
      (failure) => emit(state.copyWith(requestState: AppRequestState.failure, message: failure.message)),
      (items) => emit(state.copyWith(requestState: AppRequestState.success, cartItems: items)),
    );
  }

  FutureOr<void> _onIncrementCartItem(IncrementCartItemEvent event, Emitter<CartState> emit) async {
    final result = await addToCartUseCase.call(event.item);

    result.fold((failure) => emit(state.copyWith(message: failure.message)), (_) {
      add(GetCartEvent());
    });
  }

  FutureOr<void> _onAddToCart(AddItemToCartEvent event, Emitter<CartState> emit) async {
    final result = await addToCartUseCase.call(event.item);

    result.fold((failure) => emit(state.copyWith(message: failure.message)), (_) {
      add(GetCartEvent());
      emit(state.copyWith(message: 'تمت إضافة "${event.item.product.title}" إلى السلة 🛒'));
    });
  }

  FutureOr<void> _onRemoveFromCart(RemoveItemFromCartEvent event, Emitter<CartState> emit) async {
    final result = await removeFromCartUseCase.call(event.productId);

    result.fold((failure) => emit(state.copyWith(message: failure.message)), (_) {
      add(GetCartEvent());
      emit(state.copyWith(message: 'تم حذف المنتج من السلة 🗑️'));
    });
  }

  FutureOr<void> _onDecrementCartItem(DecrementCartItemEvent event, Emitter<CartState> emit) async {
    final result = await decrementCartItemUseCase.call(event.productId);

    result.fold((failure) => emit(state.copyWith(message: failure.message)), (_) {
      add(GetCartEvent());
    });
  }
}
