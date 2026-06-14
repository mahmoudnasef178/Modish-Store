import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/features/HomePage/logic/Favorite_Cubit/favorite_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/Favorite_Cubit/favorite_state.dart';
import 'package:graduation_project/features/profile/presentation/view/Favorite/widgets/customCardFavoriteItem.dart';

class FavoriteViewPage extends StatelessWidget {
  const FavoriteViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.shortestSide * 0.055;
    final iconHeight = size.shortestSide * 0.03;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: size.width * 0.09),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/icons/Arrow.svg",
              height: iconHeight,
            ),
          ),
        ),
        leadingWidth: size.width * 0.12,
        title: Text('Favorite', style: TextStyle(fontSize: fontSize)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: size.shortestSide * 0.12,
                    color: Colors.red,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    state.errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: size.shortestSide * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.02),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoriteCubit>().getFavorites(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (state is FavoriteSuccess) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: size.shortestSide * 0.2,
                      color: Colors.grey,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "No products",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w900,
                        color: primaryColorText,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.015,
              ),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return CustomCardFavoriteItem(item: state.items[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
