import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';

class Custombottomnavigationbar extends StatelessWidget {
  const Custombottomnavigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationCubit>().state.currentIndex;

    return BottomAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(context, Icons.home, 0, currentIndex),
            _navIcon(context, Icons.search, 1, currentIndex),
            _navIcon(context, Icons.shopping_cart, 2, currentIndex),
            _navIcon(context, Icons.person_2, 3, currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(
    BuildContext context,
    IconData icon,
    int index,
    int currentIndex,
  ) {
    return IconButton(
      onPressed: () => context.read<NavigationCubit>().changeIndex(index),
      icon: Icon(
        icon,
        size: 28,
        color: currentIndex == index ? Colors.black : Colors.grey,
      ),
    );
  }
}
