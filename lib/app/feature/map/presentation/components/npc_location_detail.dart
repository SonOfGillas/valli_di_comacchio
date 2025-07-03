import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class NpcLocationDetail extends StatelessWidget {
  const NpcLocationDetail({
    super.key,
    required this.npc,
    this.onBack,
  });

  final Npc npc;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.palette_secondary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              npc.locationImagePath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: AppColors.palette_secondary.withOpacity(0.6),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Custom AppBar
                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: AppColors.palette_primary,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: onBack ?? () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: H1(
                          npc.locationName,
                        ),
                      ),
                    ],
                  ),
                ),
                // NPC Header
                NpcDisplayHeader(
                  npc: npc,
                  npcMessage:
                      'Benvenuto,  Puoi avere più informazioni su ${npc.locationName}. oppure accettare una quest.  o commerciare con me per iniziare a fare punti',
                  expanded: true,
                ),
                const SizedBox(height: 24),
                // Glowing Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowingButton(
                        text: 'Escursioni',
                        onPressed: () {},
                        disabled: true,
                      ),
                      GlowingButton(
                        text: 'Commercia',
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.push(
                            RoutesPaths.trade,
                            extra: TradePageParameters(npcId: npc.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlowingButton(
                        text: 'Informazioni',
                        onPressed: () {},
                        disabled: true,
                      ),
                    ],
                  ),
                ),
                // Optionally, add more content here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
