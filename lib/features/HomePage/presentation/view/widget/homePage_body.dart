import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/core/utils.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/notification_View.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/products_page.dart';
import 'package:graduation_project/features/HomePage/presentation/view/recommendation/recommendation_page.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/ListView_Category.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/ListView_FeatureProducts.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/New_collection_Card.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_frame.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/recommendation_listview.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/topCollection_container.dart';
import 'package:graduation_project/features/profile/presentation/view/category/category_Page.dart';

class HomepageBody extends StatelessWidget {
  const HomepageBody({super.key, required this.globalKey});
  final GlobalKey<ScaffoldState> globalKey;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: BlocProvider(
              create: (context) => NavigationCubit(),
              child: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  return CustomAppbar(
                    leftIcon: "assets/icons/Drawer.svg",
                    title: "Modish",
                    rightIcon: "assets/icons/Notification.svg",
                    showThemeToggle: true, // ✅ هيظهر الزرار في الـ homepage بس
                    leftIconOnTap: () {
                      globalKey.currentState!.openDrawer();
                    },
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

          Stack(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
                child: Image.asset("assets/images/Mask Group (1).png"),
              ),
              Positioned(
                right: 40,
                top: 30,
                child: Text(
                  "Autumn\nCollection\n2025",
                  style: t22.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Gap(context.height * .03),
          CustomFrame(
            text1: "Category",
            text2: "Show all",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategorySection()),
              );
            },
          ),
          Gap(context.height * .03),
          ListviewCategory(),
          Gap(context.height * .03),
          CustomFrame(
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
          Gap(context.height * .03),
          ListviewFeatureProducts(),
          Gap(context.height * .03),
          NewCollectionCard(),
          Gap(context.height * .04),
          CustomFrame(
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
          Gap(context.height * .03),
          RecommendationListview(),
          Gap(context.height * .04),
          CustomFrame(text1: "Top Collection", text2: ''),
          Gap(context.height * .03),
          TopcollectionContainer(
            image: "assets/images/image48.png",
            height: 165,
            title: "Sale up to 40%",
            subTitle: "FOR SLIM \n& BEAUTY",
            imagehight: 180,
            titleHeight: 18,
            subTitleHeight: 26,
            heightContainer: 120,
            widthContainer: 120,
          ),
          Gap(context.height * .04),
          TopcollectionContainer(
            image: "assets/images/image69.png",
            height: 240,
            title: "Summer Collection 2025",
            subTitle: "Most Comfortable\n& fabulous \n design ",
            imagehight: 240,
            titleHeight: 14,
            subTitleHeight: 18,
            heightContainer: 120,
            widthContainer: 140,
          ),
          Gap(context.height * .04),
        ],
      ),
    );
  }
}
