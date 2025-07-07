import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/cards_page_screen.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CardCubit>(
      create: (context) => sl<CardCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: ValliAppBar(),
            body: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: CardPageScreen()),
            bottomNavigationBar: const FooterNavBar(),
          );
        },
      ),
    );
  }
}
