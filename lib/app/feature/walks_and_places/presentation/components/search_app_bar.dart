import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/debounce_text_field/debounce_text_field.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.clearSearch,
  });

  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback clearSearch;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.palette_primary,
      flexibleSpace: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DebouncedTextField(
              textField: AppTextField(
                controller: searchController,
                leftIcon: AppIcons.search,
                rightIcon: AppIcons.close,
                onRightIconTap: () => {
                  clearSearch(),
                  searchController.clear(),
                },
              ),
              onDebouncedChange: onSearch,
            ),
          ),
        ),
      ),
    );
  }
}
