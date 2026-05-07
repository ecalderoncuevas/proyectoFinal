import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  // Garantiza que los bindings de Flutter estén listos antes de cualquier operación asíncrona
  WidgetsFlutterBinding.ensureInitialized();

  // Fuerza la orientación vertical para toda la app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Inicializa los datos de formato de fecha para los idiomas soportados
  await initializeDateFormatting('es_ES', null);
  await initializeDateFormatting('ca_ES', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('es_ES', null);

  runApp(
    // EasyLocalization envuelve la app y gestiona las traducciones en es/ca/en
    EasyLocalization(
      supportedLocales: const [
        Locale('es'),
        Locale('ca'),
        Locale('en'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      startLocale: const Locale('es'),
      // MultiProvider inyecta ThemeProvider y UserProvider en todo el árbol de widgets
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const SynquidApp(),
      ),
    ),
  );
}

class SynquidApp extends StatelessWidget {
  const SynquidApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha cambios de tema en tiempo real para aplicarlos sin recargar la app
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'Synquid',
      debugShowCheckedModeBanner: false,
      // Aplica el modo de tema claro/oscuro según el estado del ThemeProvider
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.homeLightBg,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
      ),
      // Configuración de localización tomada del contexto de EasyLocalization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // Usa go_router como sistema de navegación declarativo
      routerConfig: appRouter,
      builder: (context, child) {
        // Escala el texto globalmente según el tamaño de fuente elegido en ajustes
        final scale = themeProvider.fontSize / 16.0;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
          ),
          child: child!,
        );
      },
    );
  }
}