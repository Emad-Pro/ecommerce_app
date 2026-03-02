import 'package:ecommerce_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/depandcy_injection.dart';
import '../../../../core/states/request_state.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/checkout_button_bar.dart';
import '../widgets/empty_cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    sl<CartBloc>().add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: .rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'سلة المشتريات',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          bloc: sl<CartBloc>(),
          builder: (context, state) {
            if (state.requestState == AppRequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.requestState == AppRequestState.failure) {
              return Center(
                child: Text(
                  state.message ?? 'حدث خطأ في تحميل السلة',
                  style: TextStyle(color: colorScheme.error, fontSize: 16),
                ),
              );
            }

            if (state.cartItems.isEmpty) {
              return const EmptyCartWidget();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: state.cartItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return CartItemCard(item: item);
                    },
                  ),
                ),

                CheckoutBottomBar(cartItems: state.cartItems),
              ],
            );
          },
        ),
      ),
    );
  }
}
