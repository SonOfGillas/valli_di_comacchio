import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_opener_example.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: ValliAppBar(),
          body: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: PackOpenerExample()

              // PackCarousel(
              //   packCount: 8,
              //   onPackSelected: (index) {
              //     // Handle pack selection
              //   },
              // ),
              ),
          bottomNavigationBar: const FooterNavBar(),
        );
      },
    );
  }
}
