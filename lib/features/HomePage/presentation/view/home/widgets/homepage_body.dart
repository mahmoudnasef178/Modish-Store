import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/core/responsive.dart';
import 'package:modish_store/core/utils.dart';
import 'package:modish_store/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:modish_store/features/HomePage/logic/Navigation_Cubit/navigation_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/notification/notification_view.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/products_page.dart';
import 'package:modish_store/features/HomePage/presentation/view/recommendation/recommendation_page.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/listview_category.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/listview_feature_products.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/new_collection_card.dart';
import 'package:modish_store/features/HomePage/presentation/view/widget/custom_app_bar.dart';
import 'package:modish_store/features/HomePage/presentation/view/widget/custom_frame.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/recommendation_listview.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/top_collection_container.dart';
import 'package:modish_store/features/HomePage/presentation/view/category/category_page.dart';

class HomepageBody extends StatelessWidget {
  const HomepageBody({super.key, required this.globalKey});
  final GlobalKey<ScaffoldState> globalKey;

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.maxContentWidth(context),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: BlocProvider(
                  create: (context) => NavigationCubit(),
                  child: BlocBuilder<NavigationCubit, NavigationState>(
                    builder: (context, state) {
                      return CustomAppbar(
                        leftIcon: "assets/icons/Drawer.svg",
                        title: "Modish",
                        rightIcon: "assets/icons/Notification.svg",
                        showThemeToggle: true,
                        showIcon: true,
                        // On mobile → open drawer; on wider screens → no-op (rail handles nav)
                        leftIconOnTap: isMobile
                            ? () => globalKey.currentState!.openDrawer()
                            : null,
                        rightIconOnTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationView(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .04),

              // ── Hero Banner ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: AspectRatio(
                  aspectRatio: Responsive.isMobile(context)
                      ? 343 / 160
                      : 343 / 80,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/images/Mask Group (1).png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: Responsive.value(
                          context,
                          mobile: 20,
                          tablet: 30,
                          desktop: 40,
                        ),
                        child: Text(
                          "Autumn\nCollection\n2025",
                          style: t22.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: Responsive.value(
                              context,
                              mobile: 20,
                              tablet: 24,
                              desktop: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gap(context.height * .03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: CustomFrame(
                  text1: "Category",
                  text2: "Show all",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategorySection(),
                      ),
                    );
                  },
                ),
              ),
              Gap(context.height * .02),
              ListviewCategory(),
              Gap(context.height * .03),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: CustomFrame(
                  text1: "Feature Products",
                  text2: "Show all",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductsPage(
                          categoryId: '',
                          categoryName: 'All Products',
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gap(context.height * .02),
              ListviewFeatureProducts(),
              Gap(context.height * .03),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: NewCollectionCard(),
              ),
              Gap(context.height * .04),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: CustomFrame(
                  text1: "Recommended",
                  text2: "Show all",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecommendedPage(),
                      ),
                    );
                  },
                ),
              ),
              Gap(context.height * .02),
              RecommendationListview(),
              Gap(context.height * .04),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: CustomFrame(text1: "Top Collection", text2: ''),
              ),
              Gap(context.height * .03),

              // ── Top Collection: stacked on mobile, side-by-side on wider ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: isMobile
                    ? Column(
                        children: [
                          TopcollectionContainer(
                            image: "assets/images/image48.png",
                            height: 200,
                            title: "Sale up to 40%",
                            subTitle: "FOR SLIM \n& BEAUTY",
                            imagehight: 220,
                            titleHeight: 18,
                            subTitleHeight: 24,
                            heightContainer: 150,
                            widthContainer: 150,
                          ),
                          Gap(context.height * .04),
                          TopcollectionContainer(
                            image: "assets/images/image69.png",
                            height: 260,
                            title: "Summer Collection 2025",
                            subTitle: "Most Comfortable\n& fabulous \n design ",
                            imagehight: 280,
                            titleHeight: 14,
                            subTitleHeight: 20,
                            heightContainer: 180,
                            widthContainer: 180,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: TopcollectionContainer(
                              image: "assets/images/image48.png",
                              height: 460,
                              title: "Sale up to 40%",
                              subTitle: "FOR SLIM \n& BEAUTY",
                              imagehight: 360,
                              titleHeight: 18,
                              subTitleHeight: 22,
                              heightContainer: 130,
                              widthContainer: 130,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TopcollectionContainer(
                              image: "assets/images/image69.png",
                              height: 200,
                              title: "Summer Collection 2025",
                              subTitle:
                                  "Most Comfortable\n& fabulous \n design ",
                              imagehight: 240,
                              titleHeight: 14,
                              subTitleHeight: 16,
                              heightContainer: 130,
                              widthContainer: 130,
                            ),
                          ),
                        ],
                      ),
              ),
              Gap(context.height * .04),
            ],
          ),
        ),
      ),
    );
  }
}
