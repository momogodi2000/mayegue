import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'dimensions.dart';

/// App Theme - Unified theme configuration
class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Colors
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.surface,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryLight,
      error: AppColors.error,
      errorContainer: AppColors.errorLight,
      surface: AppColors.surface,
      surfaceVariant: AppColors.surfaceVariant,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: AppColors.shadow,
      scrim: AppColors.scrim,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.onInverseSurface,
      inversePrimary: AppColors.inversePrimary,
      surfaceTint: AppColors.surfaceTint,
    ),

    // Typography
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      headlineLarge: AppTextStyles.headline4,
      headlineMedium: AppTextStyles.headline5,
      headlineSmall: AppTextStyles.headline6,
      titleLarge: AppTextStyles.bodyText1,
      titleMedium: AppTextStyles.bodyText2,
      titleSmall: AppTextStyles.caption,
      bodyLarge: AppTextStyles.bodyText1,
      bodyMedium: AppTextStyles.bodyText2,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.bodyText2,
      labelSmall: AppTextStyles.overline,
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: AppDimensions.elevationS,
      shadowColor: AppColors.shadow,
      surfaceTintColor: AppColors.surfaceTint,
      titleTextStyle: AppTextStyles.headline6,
      toolbarHeight: AppDimensions.appBarHeight,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedIconTheme: IconThemeData(size: AppDimensions.iconSizeM),
      unselectedIconTheme: IconThemeData(size: AppDimensions.iconSizeM),
      elevation: AppDimensions.elevationM,
      type: BottomNavigationBarType.fixed,
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.surface,
      shadowColor: AppColors.shadow,
      elevation: AppDimensions.elevationXS,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
      ),
      margin: AppDimensions.marginM,
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppDimensions.elevationS,
        shadowColor: AppColors.shadow,
        textStyle: AppTextStyles.button,
        padding: AppDimensions.paddingHorizontalL,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeightM),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMObj,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: AppTextStyles.button,
        padding: AppDimensions.paddingHorizontalL,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeightM),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMObj,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button,
        padding: AppDimensions.paddingHorizontalM,
        minimumSize: const Size(0, AppDimensions.buttonHeightM),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMObj,
        ),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppDimensions.paddingM,
      hintStyle: AppTextStyles.bodyText2.colored(AppColors.textSecondary),
      labelStyle: AppTextStyles.bodyText2,
      errorStyle: AppTextStyles.error,
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: AppDimensions.elevationL,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLObj,
      ),
      titleTextStyle: AppTextStyles.headline5,
      contentTextStyle: AppTextStyles.bodyText2,
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.inverseSurface,
      contentTextStyle: AppTextStyles.bodyText2.colored(AppColors.onInverseSurface),
      actionTextColor: AppColors.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusSObj,
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
      elevation: AppDimensions.elevationM,
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: AppTextStyles.bodyText2.semiBold,
      unselectedLabelStyle: AppTextStyles.bodyText2,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.outline,
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 1,
      space: 1,
    ),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceVariant,
      circularTrackColor: AppColors.surfaceVariant,
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceVariant;
      }),
      checkColor: MaterialStateProperty.all(AppColors.onPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusXSObj,
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceVariant;
      }),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceVariant;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.outline;
      }),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Colors
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    canvasColor: AppColors.surfaceDark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariantDark,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryVariantDark,
      error: AppColors.error,
      errorContainer: AppColors.errorDark,
      surface: AppColors.surfaceDark,
      surfaceVariant: AppColors.surfaceVariantDark,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurfaceDark,
      onError: AppColors.onError,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.outlineVariantDark,
      shadow: AppColors.shadowDark,
      scrim: AppColors.scrimDark,
      inverseSurface: AppColors.inverseSurfaceDark,
      onInverseSurface: AppColors.onInverseSurfaceDark,
      inversePrimary: AppColors.inversePrimaryDark,
      surfaceTint: AppColors.surfaceTintDark,
    ),

    // Typography (same as light theme)
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      headlineLarge: AppTextStyles.headline4,
      headlineMedium: AppTextStyles.headline5,
      headlineSmall: AppTextStyles.headline6,
      titleLarge: AppTextStyles.bodyText1,
      titleMedium: AppTextStyles.bodyText2,
      titleSmall: AppTextStyles.caption,
      bodyLarge: AppTextStyles.bodyText1,
      bodyMedium: AppTextStyles.bodyText2,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.bodyText2,
      labelSmall: AppTextStyles.overline,
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.onSurfaceDark,
      elevation: AppDimensions.elevationS,
      shadowColor: AppColors.shadowDark,
      surfaceTintColor: AppColors.surfaceTintDark,
      titleTextStyle: AppTextStyles.headline6,
      toolbarHeight: AppDimensions.appBarHeight,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondaryDark,
      selectedIconTheme: IconThemeData(size: AppDimensions.iconSizeM),
      unselectedIconTheme: IconThemeData(size: AppDimensions.iconSizeM),
      elevation: AppDimensions.elevationM,
      type: BottomNavigationBarType.fixed,
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      shadowColor: AppColors.shadowDark,
      elevation: AppDimensions.elevationXS,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
      ),
      margin: AppDimensions.marginM,
    ),

    // Button themes (same as light theme)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppDimensions.elevationS,
        shadowColor: AppColors.shadowDark,
        textStyle: AppTextStyles.button,
        padding: AppDimensions.paddingHorizontalL,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeightM),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMObj,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: AppTextStyles.button,
        padding: AppDimensions.paddingHorizontalL,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeightM),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMObj,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button,
        padding: AppDimensions.paddingHorizontalM,
        minimumSize: const Size(0, AppDimensions.buttonHeightM),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMObj,
        ),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.outlineDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.outlineDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusMObj,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppDimensions.paddingM,
      hintStyle: AppTextStyles.bodyText2.colored(AppColors.textSecondaryDark),
      labelStyle: AppTextStyles.bodyText2,
      errorStyle: AppTextStyles.error,
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: AppDimensions.elevationL,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLObj,
      ),
      titleTextStyle: AppTextStyles.headline5,
      contentTextStyle: AppTextStyles.bodyText2,
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.inverseSurfaceDark,
      contentTextStyle: AppTextStyles.bodyText2.colored(AppColors.onInverseSurfaceDark),
      actionTextColor: AppColors.inversePrimaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusSObj,
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
      elevation: AppDimensions.elevationM,
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondaryDark,
      labelStyle: AppTextStyles.bodyText2.semiBold,
      unselectedLabelStyle: AppTextStyles.bodyText2,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.outlineDark,
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariantDark,
      thickness: 1,
      space: 1,
    ),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceVariantDark,
      circularTrackColor: AppColors.surfaceVariantDark,
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceVariantDark;
      }),
      checkColor: MaterialStateProperty.all(AppColors.onPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusXSObj,
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceVariantDark;
      }),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceVariantDark;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.outlineDark;
      }),
    ),
  );
}
