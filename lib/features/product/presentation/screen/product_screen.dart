import 'package:auto_direction/auto_direction.dart';
import 'package:ecommerce_app/features/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/depandcy_injection.dart';
import '../../../../core/states/request_state.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/category_list_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    sl<ProductsBloc>().add(FetchProductsEvent());
    sl<CartBloc>().add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<CartBloc, CartState>(
      bloc: sl<CartBloc>(),
      listenWhen: (previous, current) => current.message != null && current.message != previous.message,
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AutoDirection(
                text: state.message ?? "",
                child: Text(state.message!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: Directionality(
        textDirection: .rtl,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: colorScheme.surface,
                  elevation: 0,
                  title: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                        },
                        child: CircleAvatar(backgroundColor: colorScheme.primaryContainer, child: Icon(Icons.person)),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('مرحباً بك،', style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant)),
                          Text(
                            'استكشف أفضل العروض 🔥',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    const SizedBox(width: 8),
                    _buildAppBarIcon(
                      context,
                      Icons.shopping_cart_outlined,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                      },
                    ),
                    const SizedBox(width: 16),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: SearchBarWidget(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(padding: const EdgeInsets.all(16.0), child: PromoBanner()),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الأقسام',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                            ),
                            Text(
                              'عرض الكل',
                              style: TextStyle(fontSize: 14, color: colorScheme.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const CategoriesList(),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      'المنتجات',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),
                  ),
                ),

                BlocBuilder<ProductsBloc, ProductsState>(
                  bloc: sl<ProductsBloc>(),
                  builder: (context, state) {
                    if (state.productsState == AppRequestState.loading) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const ShimmerProductCard(),
                            childCount: 6,
                          ),
                        ),
                      );
                    }

                    if (state.productsState == AppRequestState.failure) {
                      return SliverToBoxAdapter(
                        child: CustomErrorWidget(
                          message: state.message ?? 'حدث خطأ غير متوقع',
                          onRetry: () => sl<ProductsBloc>().add(FetchProductsEvent()),
                        ),
                      );
                    }

                    if (state.productsState == AppRequestState.success) {
                      if (state.filteredProducts.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: Text('لا توجد منتجات مطابقة لبحثك ', style: TextStyle(fontSize: 16))),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final product = state.filteredProducts[index];
                            return ProductCard(product: product);
                          }, childCount: state.filteredProducts.length),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(BuildContext context, IconData icon, {void Function()? onPressed}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withOpacity(0.4), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: colorScheme.onSurface, size: 22),
        onPressed: onPressed,
      ),
    );
  }
}
