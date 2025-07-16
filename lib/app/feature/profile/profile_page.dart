import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_reset_data.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.palette_secondary,
        appBar: ValliAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DevModeWidget(),
              SizedBox(height: 8),
              H2('Il tuo inventario'),
              SizedBox(height: 4),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return state.user != null
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.user?.inventory.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final resource = state.user!.inventory[index];
                              return TradeResourceElement(
                                resource: resource,
                                onTap: () {},
                                isUserResource: true,
                                showQuantityMedium: true,
                              );
                            },
                          ),
                        )
                      : Container();
                },
              ),
              SizedBox(height: 12),
              H2('Tesori trovati'),
              SizedBox(height: 4),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return state.user != null && state.collectedNFTs.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.collectedNFTs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final treasure = state.collectedNFTs[index];
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.file(treasure),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: 80,
                          child: Center(
                            child: LabelText('Nessun tesoro trovato',
                                withBoarder: false),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: FooterNavBar());
  }
}

class DevModeWidget extends StatelessWidget {
  const DevModeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Modalità Sviluppatore',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16),
                Switch(
                  value: state.devMode,
                  onChanged: (bool value) {
                    context.read<AppCubit>().setDevMode(value);
                  },
                ),
              ],
            ),
            if (state.devMode) ...[
              ElevatedButton(
                child: Text('Ricevi 10 000 monete'),
                onPressed: () {
                  if (state.user == null) return;
                  context.read<AppCubit>().updateUser(
                        state.user?.copyWith(
                          wealth: (state.user?.wealth ?? 0) + 10000,
                        ),
                      );
                },
              ),
              ElevatedButton(
                child: Text('Genera inventario casuale per l\'utente'),
                onPressed: () {
                  if (state.user == null) return;
                  context.read<AppCubit>().updateUser(
                        state.user?.copyWith(
                          inventory: generateRndInventory(),
                        ),
                      );
                },
              ),
              ElevatedButton(
                child: Text('Resetta la collezione delle carte'),
                onPressed: () {
                  if (state.user == null) return;
                  context.read<AppCubit>().updateUser(
                        state.user?.copyWith(
                          cardCollection: const {},
                        ),
                      );
                },
              )
            ],
          ],
        );
      },
    );
  }
}
