import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/components/card_detail.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/components/pack_courosel.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/components/pack_opener_example.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

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

class CardDetailDimostator extends StatefulWidget {
  const CardDetailDimostator({super.key});

  @override
  State<CardDetailDimostator> createState() => _CardDetailDimostatorState();
}

class _CardDetailDimostatorState extends State<CardDetailDimostator> {
  bool _isFoil = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Card in center
        Center(
          child: CardDetail(isFoil: _isFoil),
        ),

        // Toggle button for foil effect at the bottom
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isFoil = !_isFoil;
                });
              },
              icon: Icon(
                _isFoil ? Icons.auto_awesome : Icons.auto_awesome_outlined,
                color: _isFoil ? Colors.amber : Colors.grey,
              ),
              label: Text(
                _isFoil ? 'Holographic Effect: ON' : 'Holographic Effect: OFF',
                style: TextStyle(
                  color: _isFoil ? AppColors.palette_primary : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: _isFoil ? AppColors.palette_primary : Colors.grey,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
