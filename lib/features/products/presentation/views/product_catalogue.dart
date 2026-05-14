part of '../controllers/product_catalogue.dart';

class ProductCatalogueView extends StatelessWidget
    implements ProductCatalogueViewContract {
  const ProductCatalogueView({super.key, required this.controller});

  final ProductCatalogueControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I.get<ProductsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Gift Cards'),
          actions: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                int cartCount = 0;
                if (state is CartLoaded) {
                  cartCount = state.cart.items.length;
                }
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => controller.navigateToCart(context),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: REdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20.w,
                            minHeight: 20.h,
                          ),
                          child: Center(
                            child: Text(
                              cartCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => controller.navigateToProfile(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search
            Container(
              color: AppColors.primary,
              padding: REdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: controller.searchCtrl,
                onChanged: (v) => controller.searchProducts(v),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search gift cards...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            // Content
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return _ShimmerGrid();
                  }
                  if (state is ProductsError) {
                    return AppError(
                      message: state.message,
                      onRetry: () => controller.loadProducts(),
                    );
                  }
                  if (state is ProductsLoaded) {
                    final items = state.filtered;
                    if (items.isEmpty) {
                      return const AppEmpty(
                        title: 'No gift cards found',
                        subtitle: 'Try a different search term',
                        icon: Icons.search_off,
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => controller.cubit.loadProducts(),
                      child: GridView.builder(
                        padding: REdgeInsets.all(16),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: items.length,
                        itemBuilder: (_, i) => _ProductCard(
                          product: items[i],
                          onTap: () => controller.navigateToProductDetail(
                            context,
                            items[i],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.r)),
              child: AppNetworkImage(
                imageUrl: product.imageUrl,
                width: double.infinity,
                height: 120.h,
              ),
            ),
            Padding(
              padding: REdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Gift Card',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  6.verticalSpace,
                  if (product.country != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 12.sp,
                            color: AppColors.textSecondary),
                        4.w.horizontalSpace,
                        Expanded(
                          child: Text(
                            product.country!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  6.verticalSpace,
                  if (product.denominations.isNotEmpty)
                    Text(
                      'From ${CurrencyFormatter.formatAmount(product.denominations.first, product.currency)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (product.minValue != null)
                    Text(
                      '${CurrencyFormatter.formatAmount(product.minValue!, product.currency)} - ${CurrencyFormatter.formatAmount(product.maxValue ?? 0, product.currency)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: REdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}