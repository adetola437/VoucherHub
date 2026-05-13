part of '../controllers/product_detail.dart';

class ProductDetailView extends StatelessWidget implements ProductDetailViewContract {
  const ProductDetailView({super.key, required this.controller});

  final ProductDetailControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: AppNetworkImage(
                imageUrl: controller.product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: REdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.product.name ?? 'Gift Card',
                      style: AppTextStyles.heading2),
                  if (controller.product.country != null) ...[
                    8.verticalSpace,
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: AppColors.textSecondary),
                        4.w.horizontalSpace,
                        Text(controller.product.country!,
                            style: AppTextStyles.body2),
                        12.w.horizontalSpace,
                        if (controller.product.currency != null)
                          Container(
                            padding: REdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(controller.product.currency!,
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                  ],
                  if (controller.product.description != null) ...[
                    20.verticalSpace,
                    Text('About', style: AppTextStyles.heading3),
                    8.verticalSpace,
                    Text(controller.product.description!,
                        style: AppTextStyles.body2),
                  ],
                  24.verticalSpace,
                  // Amount selection
                  Text('Select Amount', style: AppTextStyles.heading3),
                  12.verticalSpace,
                  _AmountSelector(controller: controller),
                  24.verticalSpace,
                  // Quantity
                  Text('Quantity', style: AppTextStyles.heading3),
                  12.verticalSpace,
                  _QuantitySelector(controller: controller),
                  if (controller.product.redemptionInstructions != null) ...[
                    24.verticalSpace,
                    Text('Redemption', style: AppTextStyles.heading3),
                    8.verticalSpace,
                    Text(controller.product.redemptionInstructions!,
                        style: AppTextStyles.body2),
                  ],
                  80.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: REdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BlocConsumer<CartCubit, CartState>(
          bloc: controller.cartCubit,
          listener: (context, state) {
            if(state is CartItemAdded){
              ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                  content:  Text('Item added to cart'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.pop();
            }
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) => AppButton(
            label: 'Add to Cart',
            isLoading: state is CartLoading,
            onPressed: () => controller.addToCart(),
          ),
        ),
      ),
    );
  }
}

class _AmountSelector extends StatefulWidget {
  final ProductDetailControllerContract controller;

  const _AmountSelector({required this.controller});

  @override
  State<_AmountSelector> createState() => _AmountSelectorState();
}

class _AmountSelectorState extends State<_AmountSelector> {
  @override
  Widget build(BuildContext context) {
    final product = widget.controller.product;
    return Column(
      children: [
        if (product.hasFixedDenominations) ...[
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: product.denominations
                .map((d) => AmountBadge(
                      amount: CurrencyFormatter.formatAmount(
                          d, product.currency),
                      isSelected: widget.controller.selectedAmount == d,
                      onTap: () {
                        widget.controller.setSelectedAmount(d);
                        widget.controller.setAmountError(null);
                        setState(() {});
                      },
                    ))
                .toList(),
          ),
        ] else ...[
          TextFormField(
            controller: widget.controller.amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: product.minValue != null
                  ? '${product.minValue} - ${product.maxValue}'
                  : 'Enter amount',
              prefixText: '${product.currency ?? 'NGN'} ',
              errorText: widget.controller.amountError,
            ),
            onChanged: (_) {
              widget.controller.setAmountError(null);
              setState(() {});
            },
          ),
        ],
      ],
    );
  }
}

class _QuantitySelector extends StatefulWidget {
  final ProductDetailControllerContract controller;

  const _QuantitySelector({required this.controller});

  @override
  State<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<_QuantitySelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: widget.controller.quantity > 1
              ? () {
                  widget.controller.setQuantity(widget.controller.quantity - 1);
                  setState(() {});
                }
              : null,
          icon: const Icon(Icons.remove_circle_outline),
          color: AppColors.primary,
        ),
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Text('${widget.controller.quantity}',
              style: AppTextStyles.heading3),
        ),
        IconButton(
          onPressed: () {
            widget.controller.setQuantity(widget.controller.quantity + 1);
            setState(() {});
          },
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.primary,
        ),
      ],
    );
  }
}
