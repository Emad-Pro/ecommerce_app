import 'package:ecommerce_app/features/product/domain/entities/products_enities.dart';
import 'package:flutter/material.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/depandcy_injection.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../widgets/product_details_glass_button_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductsEnities product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.5,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                child: Hero(
                  tag: 'product_${widget.product.id}',
                  child: Image.network(widget.product.image ?? '', fit: BoxFit.contain),
                ),
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.42),

                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    tween: Tween(begin: 100.0, end: 0.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value),
                        child: Opacity(opacity: 1 - (value / 100), child: child),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _translateCategory(widget.product.category ?? ''),
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product.rating?.rate ?? 0.0}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    ' (${widget.product.rating?.count ?? 0})',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          AutoDirection(
                            text: widget.product.title ?? 'بدون اسم',
                            child: Text(
                              widget.product.title ?? 'بدون اسم',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          Text(
                            'الألوان المتاحة',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildColorDot(const Color(0xFF1F2937), true),
                              _buildColorDot(const Color(0xFF9CA3AF), false),
                              _buildColorDot(const Color(0xFFD1D5DB), false),
                              _buildColorDot(const Color(0xFFFCA5A5), false),
                            ],
                          ),
                          const SizedBox(height: 32),

                          Text(
                            'تفاصيل المنتج',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                          ),
                          const SizedBox(height: 12),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: isDescriptionExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: AutoDirection(
                              text: widget.product.description ?? '',
                              child: Text(
                                widget.product.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant, height: 1.6),
                              ),
                            ),
                            secondChild: AutoDirection(
                              text: widget.product.description ?? '',
                              child: Text(
                                widget.product.description ?? '',
                                style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant, height: 1.6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() => isDescriptionExpanded = !isDescriptionExpanded),
                            child: Text(
                              isDescriptionExpanded ? 'عرض أقل' : 'قراءة المزيد',
                              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProductDetailsGlassButtonWidget(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  ProductDetailsGlassButtonWidget(
                    icon: Icons.favorite_border_rounded,
                    iconColor: colorScheme.onSurface,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السعر الإجمالي',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$ ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                            ),
                            Text(
                              '${widget.product.price ?? 0.0}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),

                    Expanded(
                      child: BlocBuilder<CartBloc, CartState>(
                        bloc: sl<CartBloc>(),
                        builder: (context, cartState) {
                          final isInCart = cartState.cartItems.any((item) => item.product.id == widget.product.id);

                          return GestureDetector(
                            onTap: () {
                              if (!isInCart) {
                                final cartItem = CartItemEntity(product: widget.product, quantity: 1);
                                sl<CartBloc>().add(AddItemToCartEvent(cartItem));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('المنتج موجود بالفعل في سلة المشتريات 🛒'),
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: isInCart ? Colors.green : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isInCart ? Colors.green : Theme.of(context).colorScheme.primary)
                                        .withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isInCart ? Icons.check_circle_rounded : Icons.shopping_bag_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isInCart ? 'مضاف للسلة' : 'إضافة للسلة',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: color, width: 2) : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  String _translateCategory(String category) {
    switch (category) {
      case "electronics":
        return "إلكترونيات";
      case "jewelery":
        return "مجوهرات";
      case "men's clothing":
        return "ملابس رجالي";
      case "women's clothing":
        return "ملابس نسائي";
      default:
        return category;
    }
  }
}
